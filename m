Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F28358F99
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 00:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhDHWDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 18:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbhDHWDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 18:03:05 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3714C061761
        for <kvm@vger.kernel.org>; Thu,  8 Apr 2021 15:02:53 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d124so2823303pfa.13
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 15:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z78DXVE9WBm7/7q42/7ISkvRmbVqJnFckYhnNs8iZ0k=;
        b=hfODF5w2VKgIycyUnbATTLWtyJ6DfcsoXmU1GfHp77ZKjL/Di/Dccm9fqQhLM7NLjG
         EgvT5d4OBVGlbCLGYHcqh5YLg0FMgmwCcnXm4+KMOvIs00ZpKHhBr/CpvXib1yO8bJ2N
         PBce4FC3AF5R5Mr+TPuTSen7T5EpfgviaUWHgz01LpE2ou99PskAgQjfhhWwd49X2Vv8
         kBCOhMXtSe6or2qeWzjFnsEPZD24PRVoEVcKmQ3nzcPQMKdNOsoQ7fJoBVkkkH32ZvYi
         pJtCiRE0aEAwmEJpLVfzfkgsIAB8ksI+Idzr8eXj+gFt7Rwi7Swlqik4XnxiHOSXeRE8
         latQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z78DXVE9WBm7/7q42/7ISkvRmbVqJnFckYhnNs8iZ0k=;
        b=gmHseP0sHZnLI1/gOjUy/k1XaR1csa2hdxTmPJ31H0KZTPTIpEZ75QwSXMdG/Eo36X
         BNn+U1ZG+AhSKYSTxE9bxQ+AQ2aWLPdrLJxDll6s3IbuiJzyfFbXluGbcMBEh09SUd46
         CjvtssOfz7wOESwO/dfr8B6YpCYu+ZXGCSyXi+glK/BjJtpj8IIPhU7p969fSxVbl3LV
         AtfisKaTIY/T5C5EyE2jqEx6UdIsPBUSx8SXRS0357081NibJV94SgGcB+ct+lqA8GbA
         pKMhI1W60KNmrudV7kvAqIMUQKMEX5Sfh04/JsPOA+wGFDKw+0OC/lJ1B9v7YF6r62hl
         PtBQ==
X-Gm-Message-State: AOAM53297QJjKsupvEznek4URpvX+a8Iy0EYjFRffrhV4Ls3+IYgnv/I
        TLheRDX17QR2qFeLmcNeE6HU8Y4eTYBe44NUG8bAFA==
X-Google-Smtp-Source: ABdhPJwszTQSkOpz5PK9ddcCStGZo+U+nBugeFCsoraaCvy7lt6KHB1hYHWLeIX+8KssFZMVJLBYtUXljP2LRBxG8pk=
X-Received: by 2002:a63:dc56:: with SMTP id f22mr9986289pgj.287.1617919372905;
 Thu, 08 Apr 2021 15:02:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210402014438.1721086-1-srutherford@google.com>
In-Reply-To: <20210402014438.1721086-1-srutherford@google.com>
From:   Nathan Tempelman <natet@google.com>
Date:   Thu, 8 Apr 2021 15:02:41 -0700
Message-ID: <CAKiEG5pRD4+1dJW=pkpuUKudmPqeTfsVttUG22zo_8FC5_SjfA@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Add support for KVM_SEV_SEND_CANCEL command
To:     Steve Rutherford <srutherford@google.com>
Cc:     kvm <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 1, 2021 at 6:45 PM Steve Rutherford <srutherford@google.com> wrote:
>
> After completion of SEND_START, but before SEND_FINISH, the source VMM can
> issue the SEND_CANCEL command to stop a migration. This is necessary so
> that a cancelled migration can restart with a new target later.
>
> Signed-off-by: Steve Rutherford <srutherford@google.com>
> ---
>  .../virt/kvm/amd-memory-encryption.rst        |  9 +++++++
>  arch/x86/kvm/svm/sev.c                        | 24 +++++++++++++++++++
>  include/linux/psp-sev.h                       | 10 ++++++++
>  include/uapi/linux/kvm.h                      |  2 ++
>  4 files changed, 45 insertions(+)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 469a6308765b1..9e018a3eec03b 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -284,6 +284,15 @@ Returns: 0 on success, -negative on error
>                  __u32 len;
>          };
>
> +16. KVM_SEV_SEND_CANCEL
> +------------------------
> +
> +After completion of SEND_START, but before SEND_FINISH, the source VMM can issue the
> +SEND_CANCEL command to stop a migration. This is necessary so that a cancelled
> +migration can restart with a new target later.
> +
> +Returns: 0 on success, -negative on error
> +
>  References
>  ==========
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 83e00e5245136..88e72102cb900 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1110,6 +1110,27 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
>         return ret;
>  }
>
> +static int sev_send_cancel(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       struct sev_data_send_cancel *data;
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
> +       ret = sev_issue_cmd(kvm, SEV_CMD_SEND_CANCEL, data, &argp->error);
> +
> +       kfree(data);
> +       return ret;
> +}
> +
> +
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> @@ -1163,6 +1184,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>         case KVM_SEV_GET_ATTESTATION_REPORT:
>                 r = sev_get_attestation_report(kvm, &sev_cmd);
>                 break;
> +       case KVM_SEV_SEND_CANCEL:
> +               r = sev_send_cancel(kvm, &sev_cmd);
> +               break;
>         default:
>                 r = -EINVAL;
>                 goto out;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index b801ead1e2bb5..74f2babffc574 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -73,6 +73,7 @@ enum sev_cmd {
>         SEV_CMD_SEND_UPDATE_DATA        = 0x041,
>         SEV_CMD_SEND_UPDATE_VMSA        = 0x042,
>         SEV_CMD_SEND_FINISH             = 0x043,
> +       SEV_CMD_SEND_CANCEL             = 0x044,
>
>         /* Guest migration commands (incoming) */
>         SEV_CMD_RECEIVE_START           = 0x050,
> @@ -392,6 +393,15 @@ struct sev_data_send_finish {
>         u32 handle;                             /* In */
>  } __packed;
>
> +/**
> + * struct sev_data_send_cancel - SEND_CANCEL command parameters
> + *
> + * @handle: handle of the VM to process
> + */
> +struct sev_data_send_cancel {
> +       u32 handle;                             /* In */
> +} __packed;
> +
>  /**
>   * struct sev_data_receive_start - RECEIVE_START command parameters
>   *
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f6afee209620d..707469b6b7072 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1671,6 +1671,8 @@ enum sev_cmd_id {
>         KVM_SEV_CERT_EXPORT,
>         /* Attestation report */
>         KVM_SEV_GET_ATTESTATION_REPORT,
> +       /* Guest Migration Extension */
> +       KVM_SEV_SEND_CANCEL,
>
>         KVM_SEV_NR_MAX,
>  };
> --
> 2.31.0.208.g409f899ff0-goog
>

Reviewed-by: Nathan Tempelman <natet@google.com>
