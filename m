Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8AF40C9C9
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 18:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhIOQMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 12:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhIOQMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 12:12:03 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7F2C061574
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 09:10:44 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id x27so7085109lfu.5
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 09:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LG6oYYKQ5hdREOt/eg92Zw7cqO0Rzzfom1gwS1jbMGo=;
        b=CVtbjEk5K4t/prVtq6j3LDnqxK2VUaLQhWN9DR2to9qfBh1IA2zItyoEd0LcJ9i4yZ
         cexL6csyt7Av3MfMFFP1MMgcREc7JyE5RNZg0Tw2eOG07Ht5S7Ifp9lrIlwGuN14UZ3s
         c1POtIjYVGXt1Yf9wk+0o6afCv+4a39i1tHCuHGlsjZMWaMV4Dn3lwvqCPBYScOkxZ17
         jhsAxq/nOk47WeJ4JTnFI7swTWxgKDozPUGeQvLCg56o4/I1XrBjTsvIR3RrcfjYDaOy
         IqSfG7g38s0euoVDbuZ/lI/klUUIj42kwdrdz2K+zUV7wknN9ERzRM2b4rHBfA6p+prC
         /FmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LG6oYYKQ5hdREOt/eg92Zw7cqO0Rzzfom1gwS1jbMGo=;
        b=GVc6UaKrc5XgBSQvl/VU62mtJ+YA+ybvEakP79+fsWtj7JdirphuqVkj+Nvdp6SU97
         DK+cnzyqFEZhCF2gJb7myKPsKVqeJLysxS67JfPPJdz/pMSQLBuZZJOHAq00LyE4vlQW
         Kp8wlX+EoZRxShPU7TGmhPR17cZrEzBjK1pECmmR9PNzYDcMtHs4Ve0fwlxY8VWGKGRB
         ENKMjIXKcZeTLlSpZveZdLwO8Ep+SnfOf5FJr72T0sRx2XPG+XW8r57THkrSx2VX4hGR
         j9UFNgwZJHef0cTFZDejDl0EeAnsrk60NN0YYGf/Hg2bPMjgUJWeD3k+04PDgQn7Qttu
         A8Qg==
X-Gm-Message-State: AOAM53318JzJfTBApaj8IzKU2MlO2A7operWYnoxA5R0w39jXxwRwJVx
        Od/+x9IUIDslkHC5+8Nl46oOkPrFHrMYnmlyYDB9kA==
X-Google-Smtp-Source: ABdhPJwR0G1WRzA28YLxO95CjUKaPkIJXXQeDRc9wNQZlNdHnZmcAdwjge/2MmmhKBKCpnCzlllmX9brYKMNSsouk1U=
X-Received: by 2002:ac2:483b:: with SMTP id 27mr530040lft.644.1631722242444;
 Wed, 15 Sep 2021 09:10:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210914171551.3223715-1-pgonda@google.com> <YUDcvRB3/QOXSi8H@google.com>
 <CAMkAt6opZoFfW_DiyJUREBAtd8503C6j+ZbjS9YL3z+bhqHR8Q@mail.gmail.com>
 <YUDsy4W0/FeIEJDr@google.com> <CAMkAt6r9W=bTzLkojjAuc5VpwJnSzg7+JUp=rnK-jO88hSKmxw@mail.gmail.com>
 <YUDuv1aTauPz9aqo@google.com> <8d58d4cb-bc0b-30a9-6218-323c9ffd1037@redhat.com>
In-Reply-To: <8d58d4cb-bc0b-30a9-6218-323c9ffd1037@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 15 Sep 2021 10:10:31 -0600
Message-ID: <CAMkAt6oPijfkPjT4ARpVmXfdczChf2k3ACBwK0YZeuGOxMAE8Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Disable KVM_CAP_VM_COPY_ENC_CONTEXT_FROM for SEV-ES
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021 at 2:44 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 14/09/21 20:49, Sean Christopherson wrote:
> > On Tue, Sep 14, 2021, Peter Gonda wrote:
> >> I do not think so. You cannot call KVM_SEV_LAUNCH_UPDATE_VMSA on the mirror
> >> because svm_mem_enc_op() blocks calls from the mirror. So either you have to
> >> update vmsa from the mirror or have the original VM read through its mirror's
> >> vCPUs when calling KVM_SEV_LAUNCH_UPDATE_VMSA. Not sure which way is better
> >> but I don't see a way to do this without updating KVM.
> >
> > Ah, right, I forgot all of the SEV ioctls are blocked on the mirror.  Put something
> > to that effect into the changelog to squash any argument about whether or not this
> > is the correct KVM behavior.
>
> Indeed, at least KVM_SEV_LAUNCH_UPDATE_VMSA would have to be allowed in
> the mirror VM.  Do you think anything else would be necessary?

Thanks Paolo. Yes I think that only the KVM_SEV_LAUNCH_UPDATE_VMSA
ioctl needs to be allowed on the mirror VM. But I don't think that's
the only changes needed. Additionally the mirror VM will need the sev
'handle' and the sev device 'fd' copied in vm_vm_copy_asid_from(). The
handle is needed for KVM_SEV_LAUNCH_UPDATE_VMSA, the fd is required
for sev_issue_cmd(). Also you you'd need to mirror es_active bool. (I
think its quite confusing that svm_vm_copy_asid_from() only copies
some of the metadata in sev_info but I can see why as the locked pages
and cg group metadata shouldn't be copied.)  I *think* that would be
all that's needed but I haven't tried or tested this in any way.

svm_vm_copy_asid_from() {

   asid = to_kvm_svm(source_kvm)->sev_info.asid;
+ handle = to_kvm_svm(source_kvm)->sev_info.handle;
+ fd = to_kvm_svm(source_kvm)->sev_info.fd;
+ es_active = to_kvm_svm(source_kvm)->sev_info.es_active;

...

    /* Set enc_context_owner and copy its encryption context over */
    mirror_sev = &to_kvm_svm(kvm)->sev_info;
    mirror_sev->enc_context_owner = source_kvm;
    mirror_sev->asid = asid;
    mirror_sev->active = true;
+  mirror_sev->handle = handle;
+  mirror_sev->fd = fd;
+ mirror_sev->es_active = es_active;

Paolo would you prefer a patch to enable ES mirroring or continue with
this patch to disable it for now?

>
> Paolo
>
