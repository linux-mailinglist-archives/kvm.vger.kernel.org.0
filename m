Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 673CFFD0BB
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 23:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKNWIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 17:08:09 -0500
Received: from mail-io1-f43.google.com ([209.85.166.43]:40505 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfKNWIJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 17:08:09 -0500
Received: by mail-io1-f43.google.com with SMTP id p6so8612251iod.7
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 14:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jaqnjgh/UcxO26RYC4S/PWu9BJv9I+Ug4DunV/dQoao=;
        b=wRlHu4RaPJayaM8wklQEdiJ3AOBP1vR1kXRgxU0A9Y7lGJKwjiviauXd6sOUWfVg2I
         7GFSII8V+Z7MFT2nf5fDkxYqTtppp9QdtsBGPiNrCK9wrcrmblSpBfXLz1njgf1limoB
         FjYPRpJlkWZc88fjnoChVpNokGn5AiDMR69FgdME07ChEN/CYArkvFE95U7b0nAEOpz+
         ++ykVWgKNO/ieVdIMt8fEQK3FcrruP/CYIJQONAOdcMnzxbxS2MCqDjEALVEPdMgGiu7
         2df4WJNpVoPnmxiWbBQENRSyNQmGWsrOwhRtZfwkD+LeSf/DOfGM53d1tNreV6K+0Ebl
         Bvgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jaqnjgh/UcxO26RYC4S/PWu9BJv9I+Ug4DunV/dQoao=;
        b=HEX5TIf8ALUWbk+AOvXl0Z+KHAto9B7o0A8Bidhuk9X9CFEeu3midcX38aYNmntqQJ
         ya0iN0ovo4k358dHOcV1MYiUWXJ24hkRAbV8I9Qg+n8xM8takFzeYKDvpDG8uR94EsxR
         IkfmQ4cLP+2jq7yLOEt+d9XUXlrgmqPk6I9h7NGnPs88pjqA2PP7Ed7zK9m2/ocHd+Uj
         VLIv6tRRImOUkHlj9ph/U0SI5DO1AABGby3PcHw22uJeUCwqhgWuv67/cg358IrqQiF9
         TeaDzgItZvAenLofyKrstrT7QGObyiE9QuIRZzgTVWc3UzpWDGrup/thMFCzZPJi0hkL
         pVWg==
X-Gm-Message-State: APjAAAXhq6bQRA4TC1RG4Xk0RNlPaPv5S55dIQpuSY+4ereeIcrcyDhk
        3C4Z9fyvDxzt/cc+C2SXOqCk77mYSRBRVMtIlBYe273e4fQ=
X-Google-Smtp-Source: APXvYqzs6Fg27yzlcceXaw91yO4AT2aiom0PJwt7PJGwDxaO+7yZk195RulYBqTjaziGujv+HeT92JMn0hMASS6dWaM=
X-Received: by 2002:a5d:870e:: with SMTP id u14mr11389365iom.108.1573769287844;
 Thu, 14 Nov 2019 14:08:07 -0800 (PST)
MIME-Version: 1.0
References: <CALMp9eTT6oJMibHh0OTXgj83LXmjGt7CQ22Tr6NM4NRB_bfA8Q@mail.gmail.com>
 <CB679B0C-00FF-400E-B760-4AC8641252AC@oracle.com>
In-Reply-To: <CB679B0C-00FF-400E-B760-4AC8641252AC@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 14 Nov 2019 14:07:56 -0800
Message-ID: <CALMp9eRbSL+y6-LV8YSRpOBa+t0dnEG5=tc91EZy1_CZRvMYiw@mail.gmail.com>
Subject: Re: KVM_GET_MSR_INDEX_LIST vs KVM_GET_MSR_FEATURE_INDEX_LIST
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 8, 2018 at 5:58 PM Liran Alon <liran.alon@oracle.com> wrote:
>
>
> > On 7 Sep 2018, at 21:37, Jim Mattson <jmattson@google.com> wrote:
> >
> > Are these two lists intended to be disjoint? Is it a bug that
> > IA32_ARCH_CAPABILITIES appears in both?
>
> From what I understand, the difference between these two lists is the fol=
lowing:
> * KVM_GET_MSR_INDEX_LIST is list of MSRs that are emulated/virtualized by=
 KVM and
>   their value can be get/set via KVM_GET_MSRS/KVM_SET_MSRS on a *vCPU*.
> * KVM_GET_MSR_FEATURE_INDEX_LIST is a list of MSRs that are emulated/virt=
ualized by KVM
>   and their value can be get via KVM_GET_MSRS on */dev/kvm*.
>   (But can be set via KVM_SET_MSRS on a *vCPU*).
>
> It seems that the KVM_GET_MSR_FEATURE_INDEX_LIST exists only for the purp=
ose of
> userspace to be able to know how KVM plans to expose these MSRs values to=
 newly created vCPUs
> based on KVM capabilities and host CPU capabilities.
>
> If the above is correct, it seems to me that the MSRs in KVM_GET_MSR_FEAT=
URE_INDEX_LIST are actually
> suppose to be a subset of KVM_GET_MSR_INDEX_LIST. So it shouldn=E2=80=99t=
 be an issue that IA32_ARCH_CAPABILITIES
> Exist in both of them.
> However, it seems that I am wrong because KVM_GET_MSR_FEATURE_INDEX_LIST =
is not
> a subset of KVM_GET_MSR_INDEX_LIST at all. In fact, it seems that IA32_AR=
CH_CAPABILITIES is the only one
> which exists in both lists=E2=80=A6
> Also, MSR_IA32_UCODE_REV exists only in KVM_GET_MSR_FEATURE_INDEX_LIST bu=
t one can clearly see
> how it=E2=80=99s value can be get via KVM_GET_MSRS on a *vCPU* so it was =
also suppose to be part of KVM_GET_MSR_INDEX_LIST
> but it=E2=80=99s not=E2=80=A6
>
> So I=E2=80=99m left pretty confused regarding this interface. Would like =
clarification as-well :)

Here's a more basic question: Should any MSR that can be read and
written by a guest appear in KVM_GET_MSR_INDEX_LIST? If not, what's
the point of this ioctl?
