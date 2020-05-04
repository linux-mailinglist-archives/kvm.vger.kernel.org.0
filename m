Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7191C4676
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 20:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgEDSzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 14:55:39 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21351 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725956AbgEDSzi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 14:55:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588618537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cx2x2osOhFhdNBb63MzyccRaN5HnojRzjf9rZPXLgjY=;
        b=E3dcjIuWlOoN9Wfk5Ftp10xhUjV52M0ioMkGi5VyyvKuWAh7Wq44ZcPPMPf9q+GtadtEPV
        OcMUFmXjiSI+mBurpxeyG1ttkYwRxyNI5dHI9Es4NAi9j5cHazLHjH2LTOaJzX7BRMW4VZ
        SHCmsb40u0HBiOirCf17v3oJcyS7PMA=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-2l5mSl9bPR6KoDBlI5MwyA-1; Mon, 04 May 2020 14:55:33 -0400
X-MC-Unique: 2l5mSl9bPR6KoDBlI5MwyA-1
Received: by mail-qk1-f198.google.com with SMTP id a62so321897qkd.4
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 11:55:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cx2x2osOhFhdNBb63MzyccRaN5HnojRzjf9rZPXLgjY=;
        b=NJK98v4a33j77pUgdPz7dkteWkoQhl2M9Efe/A3RkTmCLzE1Mkb27+FS2ntfmS3iDW
         9eWm1vSuARdbugrj/FhStHxeodxShQUt5NC8S3fI20cM8a1sssf/kNlIXhwnqX8z9VBR
         uEdrb2G8RCXxrOeML2x7ENAod5lm9aunKYTa5HQMPzpbgwAhGqof+txWxTJFbk0AUDnf
         RkEMcmQqq8+G6i2u3Q+H63X7Zpuz7+fIVtRXhJ6s8WOk+SDGVXt6Zo3gOd5S9gwVHpfM
         21hn8uWNaojaTlIncSsta23YZL+YM0efJncSxh44yy6oUgJyIYJ8LbdSTPLatFvYafk8
         3SSw==
X-Gm-Message-State: AGi0PuZqmPWS+YGemu0Q9RQTa7dax1NWPunGV7GTB3s3yBTnX6gsx3rN
        BWjjHo+yv3qLTazjEI/Fy8suNQ0HAJkqhrJzlhWgF+IY6JV0JrdBGKxfjvmGUUaKqCpRBCxCUab
        QMv6m/FIBU22b
X-Received: by 2002:a05:620a:34a:: with SMTP id t10mr697076qkm.414.1588618533050;
        Mon, 04 May 2020 11:55:33 -0700 (PDT)
X-Google-Smtp-Source: APiQypJq+J633mf+y1J7g3ZxshaxAtV+nb5njYJJPi1tK5geEfdEQtTK5uET4NS5qWHnowkUi6cMNg==
X-Received: by 2002:a05:620a:34a:: with SMTP id t10mr697048qkm.414.1588618532684;
        Mon, 04 May 2020 11:55:32 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id p24sm12299786qtp.59.2020.05.04.11.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 11:55:32 -0700 (PDT)
Date:   Mon, 4 May 2020 14:55:30 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 0/3] KVM: x86: cleanup and fixes for debug register
 accesses
Message-ID: <20200504185530.GE6299@xz-x1>
References: <20200504155558.401468-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200504155558.401468-1-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 11:55:55AM -0400, Paolo Bonzini wrote:
> The purpose of this series is to get rid of the get_dr6 accessor
> and, on Intel, of set_dr6 as well.  This is done mostly in patch 2,
> since patch 3 is only the resulting cleanup.  Patch 1 is a related
> bug fix that I found while inspecting the code.

Reviewed-by: Peter Xu <peterx@redhat.com>

(Btw, the db_interception() change in patch 2 seems to be a real fix to me)

> 
> A guest debugging selftest is sorely needed if anyone wants to take
> a look!

I have that in my list, but I don't know it's "sorely" needed. :) It was low
after I knew the fact that we've got one test in kvm-unit-test, but I can for
sure do that earlier.

I am wondering whether we still want a test in selftests if there's a similar
test in kvm-unit-test already.  For this one I guess at least the guest debug
test is still missing.

Thanks,

-- 
Peter Xu

