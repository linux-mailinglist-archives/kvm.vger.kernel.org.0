Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB29B97FD1
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 18:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbfHUQSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 12:18:11 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42667 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727617AbfHUQSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 12:18:11 -0400
Received: by mail-lf1-f65.google.com with SMTP id s19so2229960lfb.9
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 09:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8jR9D2gXmW+K932WoUxxlF/6KvmeyZBK58+Q+QW5BRU=;
        b=PKo8ZNtRBF1V1/WUY/Mnr83hzxuhDtWz/6NgBCGInx1LkpoXSYz6reqTeJtjbZ4OSg
         EqjJtfIjnslghFBivDRcYZMgTTw6umDEz/4f+DWLuK2nohVSjNUqtgDw1KoEHvHG46Pq
         sccPKKycCEtnI3ZaHqJ5ZKNz0HSbvG1HKq0OjRaptsjrCHJupb/jDD/oxOGJC9/yyPvD
         8jR/sudpdePuARyhu3OFdm5wb8FbS/7kuBEaFSEdpG6sZr64lOD7nM5Uftz8IzezoFB4
         efGRVpSXafhgbK4QiCAmcJvKUpCgcOwxx80r8vnk232vKTy6s3gXtSsqjlNX6uSN0lBc
         Rzow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8jR9D2gXmW+K932WoUxxlF/6KvmeyZBK58+Q+QW5BRU=;
        b=aDOy/Vu29J5y26DUi7p0ePe2D3o9Ee+8FtXoMz8T8s6CMZei/NQrSc5+WyeFVHK8rD
         7vvHEWkEm+f9e9H3nRglFYZDvJG6oZ2uSXAQPFlctJSsWwMeAGSQRKxQMYaukwU0eFLG
         nzCjjJlI8EgQIDX2W+MJxn8QL/ecKSbUp0G+SvDrKlfdsH8CZSgd3VC+Ag/FM6HWAfj5
         WVg3DiKU9dVhTL+aStiA2KJ4v7v43AwUxs2uhoQ4anrhbvPq53JhYF8XhMq0AsHiHHXY
         RzmEOHg0P9CJDdQw6vZKHHfQs6T8SSZHfMiSeguLkyu/wW7F6qJY2xACDal3YjCktmDE
         /hhw==
X-Gm-Message-State: APjAAAVXWIePCyZ1RdtKCPbpkE86ClVj0PgZ6I+ySHN+FwrH7J+G/q08
        19ea82DfNdTQx4wKLvKkbiEL/FxtaSNlRe3jVKmsjQ==
X-Google-Smtp-Source: APXvYqwAq4iaLHrKlP45uvixnFRbiMUnyXOPic9DdxwrwNvogaXhJ6T/u5NDaStEixWYuRRtc8u8ueOeF+p42SfYVcs=
X-Received: by 2002:a19:2297:: with SMTP id i145mr18462977lfi.97.1566404288509;
 Wed, 21 Aug 2019 09:18:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190715210316.25569-1-aaronlewis@google.com> <87d3c508-31be-1264-e168-c72b6857d000@oracle.com>
In-Reply-To: <87d3c508-31be-1264-e168-c72b6857d000@oracle.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 21 Aug 2019 09:17:57 -0700
Message-ID: <CAAAPnDE_m0YEd6tjRVsEppP_kD5itfN2q2EBRVAvjyNPEm_+gQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: CPUID: Add new features to the guest's CPUID
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 23, 2019 at 2:42 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
>
> On 07/15/2019 02:03 PM, Aaron Lewis wrote:
> > Add features X86_FEATURE_FDP_EXCPTN_ONLY and X86_FEATURE_ZERO_FCS_FDS to the
> > mask for CPUID.(EAX=07H,ECX=0H):EBX.  Doing this will ensure the guest's CPUID
> > for these bits match the host, rather than the guest being blindly set to 0.
> >
> > This is important as these are actually defeature bits, which means that
> > a 0 indicates the presence of a feature and a 1 indicates the absence of
> > a feature.  since these features cannot be emulated, kvm should not
> > claim the existence of a feature that isn't present on the host.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > ---
> >   arch/x86/kvm/cpuid.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index ead681210306..64c3fad068e1 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -353,7 +353,8 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
> >               F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | f_mpx | F(RDSEED) |
> >               F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
> >               F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
> > -             F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
> > +             F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt |
> > +             F(FDP_EXCPTN_ONLY) | F(ZERO_FCS_FDS);
> >
> >       /* cpuid 7.0.ecx*/
> >       const u32 kvm_cpuid_7_0_ecx_x86_features =
>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

ping
