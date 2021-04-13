Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C1F35D445
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 02:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244420AbhDMAFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 20:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237883AbhDMAFi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 20:05:38 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9AEC061756
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:05:19 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id l19so8731477ilk.13
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KTTyuyVJMQ7i18qjf0Ue5SHbPHNLK214rpN4goKhaEw=;
        b=HHWJrZtVPT2QD1IqIeSMeQXU4JinLVjekhBpAuCByZjQ/dzGrtGqyejQbTbS66NOBY
         cSK5yN2WxUo0xLCQkV0DybAF5Jk1C8SJK4Ik4mwrirEFkEOUuL86HCPP0DhMcZ+zHYUr
         /JLfYdskYPn6X26TdA15XKD84GlD8fYA9HLsVI0XMA5CEoPtBcTcRXgYyZWpAoDvKzPM
         ARQ9W8b0J+6YGEhOBEIz95BrgrUCNB27RNLcgGnoxICA+dcGTFIr77l8siS7UhpJaeMw
         1LWvbCZ55J6r7rID9y1xbKvhNW5c6K/kyyNneUEpFNzK1WPZSHihO5cQquKcDteteaJz
         AjtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KTTyuyVJMQ7i18qjf0Ue5SHbPHNLK214rpN4goKhaEw=;
        b=NOkLOkSY7ikQnuD6w9cr0byUIl3sLrZHBn7hJhDwaBvt9AfWVGcNm3vgGsI3RJgQZH
         S6z6eZSh3GZ5GbbkRep7Wsz70WNPu4JsIEZHtjwYBDkh0SkKLOb8Ix9ixcx3cN8H6WzO
         VGjVuZTz/VbZkYtR5K61ZPbiBXHbM/dDG4tGjxLGtqdGb/YnuaaEvOmlStTGcY6YO0j5
         Y5JrooXoTQVceP+fU4ZA7jwifOVwkRaqCmPj966ukrRtWjnHFSa26XOobKOQfqO27Ix4
         pf0zv09eJzUQFU2DAwBYlAtDwZFqJvr0cEes1EbWYiXCTcYn744ZP9TViRMx0+Fu7x1S
         evIA==
X-Gm-Message-State: AOAM532AGyya+fiebFAHpeuoeeCqSgfeW0SERxbVNYyLMX3yG3llJo44
        X05LgFWNL7YOXpQoJNMlcLSniR3+XcXgj7dcK3h3qA==
X-Google-Smtp-Source: ABdhPJwouwMVu1+AnQk6ZzLR/pJ3RnhMJy/NRT4KCe4DeuAcUKwAZGA/lehQal/wlbGUlerGcB8iwF42eqhkATLdGic=
X-Received: by 2002:a05:6e02:12b4:: with SMTP id f20mr24668835ilr.212.1618272319235;
 Mon, 12 Apr 2021 17:05:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618254007.git.ashish.kalra@amd.com> <d08914dc259644de94e29b51c3b68a13286fc5a3.1618254007.git.ashish.kalra@amd.com>
In-Reply-To: <d08914dc259644de94e29b51c3b68a13286fc5a3.1618254007.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 12 Apr 2021 17:04:43 -0700
Message-ID: <CABayD+ckRHXwAgMz-RGP=pyqQR9N-tdC1M_cCx2kyetArkiPyQ@mail.gmail.com>
Subject: Re: [PATCH v12 06/13] KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 12:45 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The command finalize the guest receiving process and make the SEV guest
> ready for the execution.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Steve Rutherford <srutherford@google.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  .../virt/kvm/amd-memory-encryption.rst        |  8 +++++++
>  arch/x86/kvm/svm/sev.c                        | 23 +++++++++++++++++++
>  2 files changed, 31 insertions(+)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index c6ed5b26d841..0466c0febff9 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -396,6 +396,14 @@ Returns: 0 on success, -negative on error
>                  __u32 trans_len;
>          };
>
> +15. KVM_SEV_RECEIVE_FINISH
> +------------------------
> +
> +After completion of the migration flow, the KVM_SEV_RECEIVE_FINISH command can be
> +issued by the hypervisor to make the guest ready for execution.
> +
> +Returns: 0 on success, -negative on error
> +
>  References
>  ==========
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 2c95657cc9bf..c9795a22e502 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1524,6 +1524,26 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>         return ret;
>  }
>
> +static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       struct sev_data_receive_finish *data;
> +       int ret;
> +
> +       if (!sev_guest(kvm))
> +               return -ENOTTY;
> +
> +       data = kzalloc(sizeof(*data), GFP_KERNEL);
> +       if (!data)
> +               return -ENOMEM;
> +
> +       data->handle = sev->handle;
> +       ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, data, &argp->error);
> +
> +       kfree(data);
> +       return ret;
> +}
> +
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> @@ -1592,6 +1612,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>         case KVM_SEV_RECEIVE_UPDATE_DATA:
>                 r = sev_receive_update_data(kvm, &sev_cmd);
>                 break;
> +       case KVM_SEV_RECEIVE_FINISH:
> +               r = sev_receive_finish(kvm, &sev_cmd);
> +               break;
>         default:
>                 r = -EINVAL;
>                 goto out;
> --
> 2.17.1
>
Reviewed-by: Steve Rutherford <srutherford@google.com>
