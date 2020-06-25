Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04306209ACF
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 09:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390330AbgFYHx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 03:53:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26719 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726930AbgFYHxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 03:53:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593071604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ynck+4XeRB5o/nAH8FvdWG6Q5cXbjS/vIoJ1d8F0QNI=;
        b=QdpqfercvMv2euan1h6IpD5GpBLdAQ8+KnuZvL7cLL+LLsNTTq+5M0+ZQ95BDjoA+xL39J
        xfseDS8LSwQVsWiHuQ99cMXkFaST0lx1bT3kSgKnV1M3H4OACKESFTjWXukYt2nu/2fdqO
        O0ezT8ZgtaccSMriy7y0kbqteU2OWFM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-nuvLY76RNkmvkmZIBcnonA-1; Thu, 25 Jun 2020 03:53:22 -0400
X-MC-Unique: nuvLY76RNkmvkmZIBcnonA-1
Received: by mail-wr1-f70.google.com with SMTP id m14so6223067wrj.12
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 00:53:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ynck+4XeRB5o/nAH8FvdWG6Q5cXbjS/vIoJ1d8F0QNI=;
        b=VwcWXFSZR70YE1lxaO4RDblsXdffmbc4i+Sl3WRZTrJUwkQoZIHBlxdbZnrknkL/hT
         XHkJ4y4FynKYhwGgvCKNlxJyALqPQ5nUuPmajy66FHd35jbIYBP1/7eVBt4pofYcCAIF
         6y/g17JmtXAEZbrAipcV7RnOLh9BHbEnmoacu32W5gkwzErh9hwRXNOSW+xusOlIJa0l
         V400I/ZVbZr961QPF9ufMyz+a+vt85pFzEfnxYYiLPV1I/Okyu6PYO761+lBFBxzauvC
         WTckNjyQyyhhlz6DjfVsHr9IoAELOAvUnvIWb55Kkw3bKCtRJlY8J33adXpanJTXHWg5
         JZCA==
X-Gm-Message-State: AOAM530Pi7bPXweB8Wly+7colCr2QFUq/ztf/qBD//U542Mx+PEy3mDR
        UijUNPN1x1QIQs8HFcVSNx/3UCzr82D9AU8J7uoWDCy7fyYQSJUTr40uLo72HZ9A7ai/0gRAGXs
        x42OU97NE0zg5
X-Received: by 2002:adf:df03:: with SMTP id y3mr33592172wrl.376.1593071600745;
        Thu, 25 Jun 2020 00:53:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy929kM6SqkvoDSBqbNn9Pi+shHgfgvq2gm2KvmOc9sU+kcBzjiMshXUWG5kFMMzrQ2r3BTNw==
X-Received: by 2002:adf:df03:: with SMTP id y3mr33592151wrl.376.1593071600505;
        Thu, 25 Jun 2020 00:53:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91d0:a5f0:9f34:4d80? ([2001:b07:6468:f312:91d0:a5f0:9f34:4d80])
        by smtp.gmail.com with ESMTPSA id j14sm30337492wrs.75.2020.06.25.00.53.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 00:53:19 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Initialize segment selectors
To:     Nadav Amit <namit@vmware.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20200623084132.36213-1-namit@vmware.com>
 <40203296-7f31-16c7-bebb-e1f1cd478a19@redhat.com>
 <a9956a6f-5049-af9f-4e26-e37eb26e19c6@redhat.com>
 <3A313913-BDFC-496B-8F44-4760333E306C@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <66892b98-b3de-5e2c-d54c-a7fec812727e@redhat.com>
Date:   Thu, 25 Jun 2020 09:53:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <3A313913-BDFC-496B-8F44-4760333E306C@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/20 19:28, Nadav Amit wrote:
> Unfortunately this change does not work for me (i.e., it breaks the
> task-switch test on my setup). Admittedly, my patch was wrong.
> 
> I actually did not notice this scheme of having the GS descriptor and
> GS-base out of sync. It seems very fragile, specifically when you have a
> task-switch that reloads the GS and overwrites the original value.
> 
> I will try to investigate it further later.

Yeah, it's fragile but it's limited to the task switch tests; and it's
the only way to do it without having a separate selector or LDT for each
CPU.

Paolo

