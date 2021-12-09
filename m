Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512F246E793
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 12:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbhLILbM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 06:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbhLILbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 06:31:12 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B173BC061746;
        Thu,  9 Dec 2021 03:27:38 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id z5so18616302edd.3;
        Thu, 09 Dec 2021 03:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=86tk+RsoMIlYy34p/NNydvCeA5qxbsTCNKyRTnWUx5c=;
        b=mCTGqgvQ2y9L5RkYlOkwfaVrIWKECJ5icSrpdj9xx+3TUlSaQYL1P9i8X8qw5XjJw0
         YghfPc4XHzty2rnoR3q/Y9oAkp7kxihTyr8BQjpH4Ot8YhNjy9RLkTkzkzHoCrGhOxaz
         2bchM1Otxw28WGWbxv/waNMe4QJEG5lATgqrt/KjeKhGZfchrVETo19QrxzsJgFAKo/S
         aadedutmKirbwPjTlzU64RgPqN3FSzmKLYvjwL88bijzceH5TekcOlmMHG65KS7Y3Tn7
         O/80KTYX2atQzZtEbkGluXCAeR3dbO9D0w0yJuYLEgxth30OCk+QlZuP2QzSAyle7w4e
         2v1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=86tk+RsoMIlYy34p/NNydvCeA5qxbsTCNKyRTnWUx5c=;
        b=LLbiwi4+BEjIS8JGsDz3XsgHxt2xEUZ4GhGmHFx5oVvIPIdxNSx/3LbuKgWiSbB01p
         LTWUE7q60fDIIz5BQuowzvFbGeVPMGPmCVG0RPp8UmeLAXMRYDmJR0/riOOsp5CNKJ5H
         RzCfl9GFizot1fqGsJDuG/nUS6wguW5efgMAaCLv2JLfWcZnmGRXlZzpHnmfk+aqTEtb
         hQO/BDvjKnUSp+a58TduUZhPHFJ9CFAR33c6wPvSY1Tr/JEWKILQ0XqRy6zZLyPWzgiY
         Ac39UJTteElj38iffV4ECs1Lyzr30SdF7hpH0G7O5EGRq1r2M5rAup5At0A1sITOhHNg
         t6NA==
X-Gm-Message-State: AOAM532Ck0HUC2hPZtu2WRHgMSesyDuqKYo8yXYmEH3U/FEX+t1CZYXA
        FfVVH42wSJi0H/bDFGXVo5pd/MRZf1U=
X-Google-Smtp-Source: ABdhPJz3gRtIWeqGeEN701gfZg+2amWOqzpNJjrS5NcvJHyG53DsbG0V0QUYt+umT1PYiQ0jTsdO7A==
X-Received: by 2002:a17:907:6291:: with SMTP id nd17mr14983746ejc.194.1639049256458;
        Thu, 09 Dec 2021 03:27:36 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id hw8sm2765901ejc.58.2021.12.09.03.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 03:27:36 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <cd34bb69-e204-57b5-01b1-1834337dcd36@redhat.com>
Date:   Thu, 9 Dec 2021 12:27:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 3/3] selftests: sev_migrate_tests: Add mirror command
 tests
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>
References: <20211208191642.3792819-1-pgonda@google.com>
 <20211208191642.3792819-4-pgonda@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211208191642.3792819-4-pgonda@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 20:16, Peter Gonda wrote:
> Add tests to confirm mirror vms can only run correct subset of commands.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>   .../selftests/kvm/x86_64/sev_migrate_tests.c  | 55 +++++++++++++++++--
>   1 file changed, 51 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> index 4bb960ca6486..80056bbbb003 100644
> --- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> +++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> @@ -21,7 +21,7 @@
>   #define NR_LOCK_TESTING_THREADS 3
>   #define NR_LOCK_TESTING_ITERATIONS 10000
>   
> -static void sev_ioctl(int vm_fd, int cmd_id, void *data)
> +static int __sev_ioctl(int vm_fd, int cmd_id, void *data, __u32 *fw_error)
>   {
>   	struct kvm_sev_cmd cmd = {
>   		.id = cmd_id,
> @@ -30,11 +30,20 @@ static void sev_ioctl(int vm_fd, int cmd_id, void *data)
>   	};
>   	int ret;
>   
> -
>   	ret = ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
> -	TEST_ASSERT(ret == 0 && cmd.error == SEV_RET_SUCCESS,
> +	*fw_error = cmd.error;
> +	return ret;
> +}
> +
> +static void sev_ioctl(int vm_fd, int cmd_id, void *data)
> +{
> +	int ret;
> +	__u32 fw_error;
> +
> +	ret = __sev_ioctl(vm_fd, cmd_id, data, &fw_error);
> +	TEST_ASSERT(ret == 0 && fw_error == SEV_RET_SUCCESS,
>   		    "%d failed: return code: %d, errno: %d, fw error: %d",
> -		    cmd_id, ret, errno, cmd.error);
> +		    cmd_id, ret, errno, fw_error);
>   }
>   
>   static struct kvm_vm *sev_vm_create(bool es)
> @@ -226,6 +235,42 @@ static void sev_mirror_create(int dst_fd, int src_fd)
>   	TEST_ASSERT(!ret, "Copying context failed, ret: %d, errno: %d\n", ret, errno);
>   }
>   
> +static void verify_mirror_allowed_cmds(int vm_fd)
> +{
> +	struct kvm_sev_guest_status status;
> +
> +	for (int cmd_id = KVM_SEV_INIT; cmd_id < KVM_SEV_NR_MAX; ++cmd_id) {
> +		int ret;
> +		__u32 fw_error;
> +
> +		/*
> +		 * These commands are allowed for mirror VMs, all others are
> +		 * not.
> +		 */
> +		switch (cmd_id) {
> +		case KVM_SEV_LAUNCH_UPDATE_VMSA:
> +		case KVM_SEV_GUEST_STATUS:
> +		case KVM_SEV_DBG_DECRYPT:
> +		case KVM_SEV_DBG_ENCRYPT:
> +			continue;
> +		default:
> +			break;
> +		}
> +
> +		/*
> +		 * These commands should be disallowed before the data
> +		 * parameter is examined so NULL is OK here.
> +		 */
> +		ret = __sev_ioctl(vm_fd, cmd_id, NULL, &fw_error);
> +		TEST_ASSERT(
> +			ret == -1 && errno == EINVAL,
> +			"Should not be able call command: %d. ret: %d, errno: %d\n",
> +			cmd_id, ret, errno);
> +	}
> +
> +	sev_ioctl(vm_fd, KVM_SEV_GUEST_STATUS, &status);
> +}
> +
>   static void test_sev_mirror(bool es)
>   {
>   	struct kvm_vm *src_vm, *dst_vm;
> @@ -243,6 +288,8 @@ static void test_sev_mirror(bool es)
>   	if (es)
>   		sev_ioctl(dst_vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
>   
> +	verify_mirror_allowed_cmds(dst_vm->fd);
> +
>   	kvm_vm_free(src_vm);
>   	kvm_vm_free(dst_vm);
>   }
> 

Queued, thanks.

Paolo
