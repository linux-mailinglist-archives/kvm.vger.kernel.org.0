Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1517E53D507
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 05:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350379AbiFDDMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 23:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245608AbiFDDMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 23:12:00 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1832BCC
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 20:11:57 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id k11so12674285oia.12
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 20:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DRI9cKAgY3QVATHOoo0D04BM6oqFmuon1T3veMdSR+0=;
        b=Y5dr4A3Zl+CHMSVikGZoL33DFqP1Ta6+bUVZhRlZ3PCaU7C5m+936veqa7BiGx4IYs
         XzWM4ttXOp/WcBfO+0ZTVUYO5MXeljq3tDJgcRi/QarbLc3xzgFjCzsp3n35icBn4Z+M
         nFV/A/TShU6j2UkfIZje8i7UlzIiLT0xr2T7GrtyOPTiZgyZnSVU/jZ9XdnV03pMjGui
         /euJyDBkQeDxSUj3VvCuoL01Tt+8mlkrJQF628C45Uyq4myYludKKSqCsLOh4gS4b/DI
         MvEYSere7DJG9lohEwLusPnJJ0FUrhhgX9hdrycc79QSa2SdNs0HD3vw9zIC3jTUGkiY
         CV7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DRI9cKAgY3QVATHOoo0D04BM6oqFmuon1T3veMdSR+0=;
        b=g/NcEaZViqpvu6Mw4DCdErUbQr9kh1WI9BfFFwPnSH1pvnYUCZl64pYNVUzJQARpW5
         KY0QQgXhD6qKIdzh8q32GQnmwrJoSzGVTUAboE937+ZMA1Wrqlu0Zki7W1XXoAFgZoh/
         JDPaNSHvNzFgA92Rpn4tviev713D5tShK5m5I2d6exHodFQXCvQ0VWozvlKp9GJ+l63X
         X9n9FvbxhtOlbzUSYIO2hVVExjcLVvR9amnMKVLOhADnB6ZfgUXYJEP0yilqnwmlSMUr
         DajBfCfhRqX33NbU25feiCPdfenxV51WDWaxuTWHvco+Ifpd2oeaQDiSOBFLqFC6PwTS
         Un4Q==
X-Gm-Message-State: AOAM530O17CVe2CSFP1hAe1nodf4iJFn5HLLjX3WIWji9nkzcomaBrTa
        dM+KalmzH4CC0PJeEUBdfiYnBGXIc8bXts60SLjvtA==
X-Google-Smtp-Source: ABdhPJw7zRKTlpwlxLwwTmj2JLF92ACw1tSW3xIFPtPTlzb57s1gXYD8rM9t7Jt6Cmnk6x3nWFfDtJn8cKz5DQEeDWs=
X-Received: by 2002:a05:6808:1189:b0:32b:7fb5:f443 with SMTP id
 j9-20020a056808118900b0032b7fb5f443mr23865041oil.269.1654312316075; Fri, 03
 Jun 2022 20:11:56 -0700 (PDT)
MIME-Version: 1.0
References: <161188083424.28787.9510741752032213167.stgit@bmoger-ubuntu> <161188100955.28787.11816849358413330720.stgit@bmoger-ubuntu>
In-Reply-To: <161188100955.28787.11816849358413330720.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 3 Jun 2022 20:11:45 -0700
Message-ID: <CALMp9eTU5h4juDyGePnuDN39FudYUqyAnnQdALZM8KfiMo93YA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
To:     Babu Moger <babu.moger@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, fenghua.yu@intel.com, tony.luck@intel.com,
        wanpengli@tencent.com, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, peterz@infradead.org, seanjc@google.com,
        joro@8bytes.org, x86@kernel.org, kyung.min.park@intel.com,
        linux-kernel@vger.kernel.org, krish.sadhukhan@oracle.com,
        hpa@zytor.com, mgross@linux.intel.com, vkuznets@redhat.com,
        kim.phillips@amd.com, wei.huang2@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 28, 2021 at 4:43 PM Babu Moger <babu.moger@amd.com> wrote:

> This support also fixes an issue where a guest may sometimes see an
> inconsistent value for the SPEC_CTRL MSR on processors that support
> this feature. With the current SPEC_CTRL support, the first write to
> SPEC_CTRL is intercepted and the virtualized version of the SPEC_CTRL
> MSR is not updated. When the guest reads back the SPEC_CTRL MSR, it
> will be 0x0, instead of the actual expected value. There isn=E2=80=99t a
> security concern here, because the host SPEC_CTRL value is or=E2=80=99ed =
with
> the Guest SPEC_CTRL value to generate the effective SPEC_CTRL value.
> KVM writes with the guest's virtualized SPEC_CTRL value to SPEC_CTRL
> MSR just before the VMRUN, so it will always have the actual value
> even though it doesn=E2=80=99t appear that way in the guest. The guest wi=
ll
> only see the proper value for the SPEC_CTRL register if the guest was
> to write to the SPEC_CTRL register again. With Virtual SPEC_CTRL
> support, the save area spec_ctrl is properly saved and restored.
> So, the guest will always see the proper value when it is read back.

Note that there are actually two significant problems with the way the
new feature interacts with the KVM code before this patch:
1) All bits set by the first non-zero write become sticky until the
vCPU is reset (because svm->spec_ctrl is never modified after the
first non-zero write).
2) The current guest IA32_SPEC_CTRL value isn't actually known to the
hypervisor. It thinks that there are no writes to the MSR after the
first non-zero write, so that sticky value will be returned to
KVM_GET_MSRS. This breaks live migration.

Basically, an always-on V_SPEC_CTRL breaks existing hypervisors. It
must, therefore, default to off. However, I see that our Rome and
Milan CPUs already report the existence of this feature.
