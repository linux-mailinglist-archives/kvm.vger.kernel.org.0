Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183941EB3AF
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 05:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgFBDND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 23:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbgFBDND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 23:13:03 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086A4C061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 20:13:03 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t7so769432plr.0
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 20:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gOfNfr4/NHG9KND+o0a1b/Gj7rxxI014ehcAKIZjcMs=;
        b=boYq3m8nCPLXRifOJ1WwC2ljtjG6XWKE9h/sumj5nnr2ZW1l0SiqOafj5cYF2Lboe1
         3TiPzISIdIUiIbN1PwvKO6DPPaJqH3n8ZqM0otGLILLBsCJT7Gx3ZEiZcr3jviJacz7l
         0FkDeOykZ7wY/QSQWdRCFx8CN3xIlbGrZAkEgA7c4UpY4wpMKsE4V9l02Sl1tkEOpqEl
         +1kmL50irun4eCx+oCmipk16bgrdKsn7Se7+wel4a5oo3H6m/6PcBX1wR9gdg8evRo9G
         kZ0WVVXFcqmAnfYIvjwHeti39vGIfpNvRFzHXUXwTmclBuIQpYNbnfPAJ+qc0PURoGKC
         P3Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gOfNfr4/NHG9KND+o0a1b/Gj7rxxI014ehcAKIZjcMs=;
        b=gygoLaF4NyVtUuq6tnQfFfyckwDTTWEyIsYmzzAUmu99ue6BLb2/mxMTEBn9X26KFi
         n8zfxlRT0jEhqjK1HRe46rddsvBSZrPF+svUVk7mr6vjjRUeKkBGwFRsBdEsZSvyTGi2
         E+RKyCwg1XdzwgJzKMHQajo+9qwW4XSOdXG99Lkv+zuHh8G9quOZwl01/OMZJ/rajvrr
         eAyghTFo86tGh9uQp4plNwk4YsA0js0AC6O/U7cy21IUitM/e3R4Zrwt6fIEjX13fhDJ
         lk+zFtSMseHDxvtqPX6DNj/JalkmuBzK1epGGEaCe1MzGUT9FUtIrv+BnagYSeX36h47
         rkXA==
X-Gm-Message-State: AOAM532PX5UV5REi6zHc3x69yWRKjF2kPcN93Rq2nQ9rDKu1YOrJ+mD6
        0IwkFSORgUKgqxzfdd0cDMN4EhhbDIY=
X-Google-Smtp-Source: ABdhPJzy5GxChjWEy3NR09rs23TaguUIEtLZW0NK73L6fQJahVPYQn+4SBYsycjw6w7PkoFOLWkAbg==
X-Received: by 2002:a17:90a:218c:: with SMTP id q12mr2692924pjc.116.1591067582586;
        Mon, 01 Jun 2020 20:13:02 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id hb3sm729170pjb.57.2020.06.01.20.13.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 20:13:01 -0700 (PDT)
Subject: Re: [RFC v2 07/18] target/i386: sev: Remove redundant policy field
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-8-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <cad6754f-1014-3d77-fd21-113c4f73409b@linaro.org>
Date:   Mon, 1 Jun 2020 20:13:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-8-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/20 8:42 PM, David Gibson wrote:
> SEVState::policy is set from the final value of the policy field in the
> parameter structure for the KVM_SEV_LAUNCH_START ioctl().  But, AFAICT
> that ioctl() won't ever change it from the original supplied value which
> comes from SevGuestState::policy.
> 
> So, remove this field and just use SevGuestState::policy directly.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  target/i386/sev.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

