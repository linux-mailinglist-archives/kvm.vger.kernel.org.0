Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4D22B0C81
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 19:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgKLSWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 13:22:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60839 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726473AbgKLSWu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 13:22:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605205369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f5cbR8L4WTdXyMabbODL5fkyfdk+cAz9B1uyKh0iCm0=;
        b=frpfrOY8lMaExtHInb5uold3KHGHPtTs/CFlsB6xfT2vcPK7Fpn1FTmUH17V8sEMhgb7Ih
        tCIHB3ug2nRpk7VzkKjWogki23X4Jai9jFDqsIM85MRLxSsUUu5FZIoFGWUSaweHnXEJuY
        0JEBDkY4U5k085pvkZOmiJYCpwajhRA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-lckYapwtNP2rxvwiZFhkMQ-1; Thu, 12 Nov 2020 13:22:47 -0500
X-MC-Unique: lckYapwtNP2rxvwiZFhkMQ-1
Received: by mail-qv1-f72.google.com with SMTP id x9so2462257qvt.16
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 10:22:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f5cbR8L4WTdXyMabbODL5fkyfdk+cAz9B1uyKh0iCm0=;
        b=qQhenYEzmA6sTDFTxOPMdt7IAhF9BOTTwrZ3GRUBkWsdIM6/38SHp3pLA6N8BXucp4
         WhUPCrRgnN2Q6+sL/4a46FBxhzx70vfAyS4NdBnQkUGyJneQG4Gf/qwnt+Uv6zEnAYEx
         nO4Cg+BXHp3Tl7eoK2PyNLHa3w4kDBrA4zAidtqRO1iY9pVzJBtnfuP7UdbmiTr5CdO8
         pRquAByKAkvButZhVO7fQQemQJJuUDwFSQfNmxZJDZYYWnMoyb7jJAAK1WLv2/hV9Fxc
         bE5ONaWyVN4q7lNBIfgdCg0XQOcynaufPeZcnluVns/K7TUtzwJhvK7wRgQTu5AKlAMD
         degA==
X-Gm-Message-State: AOAM532z+36eD9Y5T91zCOVO/mjvrdDfNjTOeRddlXIOfxQOgEOErcvT
        jjtGfUTiFmlmayOBbcKFSAqJDaqP+S6oyf/fynmPeb5B8TbJoDs8zqLpaXxIj3YyeVOJJ3aNcH/
        WUTCXhtwgCmi+
X-Received: by 2002:a37:a110:: with SMTP id k16mr1106795qke.285.1605205367367;
        Thu, 12 Nov 2020 10:22:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwLtlVr62CHuyaeb2OiP7oJoby1wFnTEV+EO/pkIWJcZYL/9rZkz7IGxPcC7VLcDgpIKrSYeA==
X-Received: by 2002:a37:a110:: with SMTP id k16mr1106779qke.285.1605205367181;
        Thu, 12 Nov 2020 10:22:47 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id w54sm5636308qtb.0.2020.11.12.10.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 10:22:46 -0800 (PST)
Date:   Thu, 12 Nov 2020 13:22:45 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, bgardon@google.com
Subject: Re: [PATCH v2 09/11] KVM: selftests: Also build dirty_log_perf_test
 on AArch64
Message-ID: <20201112182245.GW26342@xz-x1>
References: <20201111122636.73346-1-drjones@redhat.com>
 <20201111122636.73346-10-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201111122636.73346-10-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 11, 2020 at 01:26:34PM +0100, Andrew Jones wrote:
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

