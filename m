Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B08645B952
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 12:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241460AbhKXLoB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 06:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241385AbhKXLoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 06:44:00 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1BCC061574
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 03:40:51 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id c4so3611783wrd.9
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 03:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=2K0wsomzgh65pxyMR01YlCbXKdEx0pDcUxqUMns577k=;
        b=Sfu3deC8QPpKw8RLoNIOunpBhi3wbkvbFEAU+b9GYNCt65IE6wMyF0nKcKxYURkLrx
         soFCapY8m7USXq0UN+WYlLeRLD0eaTXatpamAnvWMwbHO9OuOK1xNfUMZu1W06lVD0tr
         CLN81fGb9GJ9GCAEKJ6v1Gry2ZtYPxptuFJb0X9QIKZG2SpDnOg5B1le82M/xY+Us8vT
         j26x8aszNuzSWVHUq5QOGd6kUFPV12AchtaNke+GsasuY9/1g1RTCHpf8lHzALPFvk6A
         FCGmm5lWE++dvYOzTiISAG1TaXugAddQC1DPVS9VJsxCAoulnBROZxWlPTFqM5zRR8Pg
         bsdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=2K0wsomzgh65pxyMR01YlCbXKdEx0pDcUxqUMns577k=;
        b=PmvrW3YSFEAVUL5lHQquCmVTxsbv1IMj7WVlwSdjONnzSpNKhuHsETE/oQ8Rm0bGsU
         KCMYOEVvj8bRuftDDGkLHKfybDILWooKgLorFbVtT5ff7XnEI3vFBassFs73bQWbq+qj
         qkMMoNluI4Ws1iC4DGPKWvf/D+7f+qNngZNUoKjHhJ43O6G0fv1Ud09nWtcQ0itBjdaM
         IwC8+os30ESoaf6fdj62LQMWphykem9cr1EZN1syLRBIsUx9/rX8wROUMw6Xk0ZYn2JD
         kA6am8XAGNPloDRmt65RIq07x4xnjvIsRqWNdnZzXGMN1rTEw7exYI6muqthVg8sQ6pI
         gleg==
X-Gm-Message-State: AOAM533Tary7FMVc9qkWehTZ4B7igps0/U2ldYF2fD0GKwns4AosG1vf
        oaJTnggHq6sSgXmE4ImX2h5dh3R4ZZAC/w==
X-Google-Smtp-Source: ABdhPJzRW8uzG46gcBI49r340DNmx92ia6YGcRI1t9MGnAGV8eyVJJHrLIBpiKqfjwlrVEr9f+/oug==
X-Received: by 2002:adf:e0d0:: with SMTP id m16mr17852876wri.74.1637754049648;
        Wed, 24 Nov 2021 03:40:49 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id z14sm15521995wrp.70.2021.11.24.03.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 03:40:48 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id DB9DE1FF96;
        Wed, 24 Nov 2021 11:40:47 +0000 (GMT)
References: <20211118184650.661575-1-alex.bennee@linaro.org>
 <20211118184650.661575-2-alex.bennee@linaro.org>
 <20211124110659.jhjuuzez6ij5v7g7@gator.home>
User-agent: mu4e 1.7.5; emacs 28.0.60
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, qemu-arm@nongnu.org,
        idan.horowitz@gmail.com, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [kvm-unit-tests PATCH v8 01/10] docs: mention checkpatch in the
 README
Date:   Wed, 24 Nov 2021 11:38:16 +0000
In-reply-to: <20211124110659.jhjuuzez6ij5v7g7@gator.home>
Message-ID: <87y25dhjcw.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Andrew Jones <drjones@redhat.com> writes:

> On Thu, Nov 18, 2021 at 06:46:41PM +0000, Alex Benn=C3=A9e wrote:
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> ---
>>  README.md | 2 ++
>>  1 file changed, 2 insertions(+)
>>=20
>> diff --git a/README.md b/README.md
>> index b498aaf..5db48e5 100644
>> --- a/README.md
>> +++ b/README.md
>> @@ -182,3 +182,5 @@ the code files.  We also start with common code and =
finish with unit test
>>  code. git-diff's orderFile feature allows us to specify the order in a
>>  file.  The orderFile we use is `scripts/git.difforder`; adding the conf=
ig
>>  with `git config diff.orderFile scripts/git.difforder` enables it.
>> +
>> +Please run the kernel's ./scripts/checkpatch.pl on new patches
>
> This is a bit of a problem for kvm-unit-tests code which still has a mix
> of styles since it was originally written with a strange tab and space
> mixed style. If somebody is patching one of those files we've usually
> tried to maintain the original style rather than reformat the whole
> thing (in hindsight maybe we should have just reformatted). We're also
> more flexible with line length than Linux, although Linux now only warns
> for anything over 80 as long as it's under 100, which is probably good
> enough for us too. Anyway, let's see what Paolo and Thomas say. Personally
> I wouldn't mind adding this line to the documentation, so I'll ack it.
> Anyway, we can also ignore our own advise when it suits us :-)
>
> Acked-by: Andrew Jones <drjones@redhat.com>

I can make the wording more weaselly:

 We strive to follow the Linux kernels coding style so it's recommended
 to run the kernel's ./scripts/checkpatch.pl on new patches.

I added this reference because on the older iterations of these test
divergence from the kernel coding style was pointed out and I've fixed
them in this iteration.

>
> Thanks,
> drew


--=20
Alex Benn=C3=A9e
