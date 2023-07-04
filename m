Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5EC746DEB
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 11:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjGDJqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 05:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjGDJqk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 05:46:40 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBEE99
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 02:46:38 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3fba5a8af2cso55644045e9.3
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 02:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688463997; x=1691055997;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4aSLqCS1Gj0I6/4Mma9xzM2KAL8Ih3WglTvqIOK6YZA=;
        b=ULqObt0oMvFjeY3HIwS4IevWv0Zm/Z7/QPNb6wEnG/8SNRsuJXH8+swYPV2njAL9NK
         Hy/8Ktx5klp8ow7NbDEdbiKb2JcmGF96gIJTgUFI7D+LwfjMR0Z0Yo9Ie7mamUwI1rRU
         b4QjXVrscT/DeczdKQIiB1dQ5xUDdSsk56c+iYVqDpCfy7fD0F80BPOYPpYv0Qi2w1c5
         T7dfYRu+VImJWhlKx0FSm8eTHF0qBMZviNmxQFRpjffFu2t784t4Gx/+A9jSOhI187oO
         HuTpYgeE/Tc+lIrRI8PhZ7G1ngm4NX+Y9ur7Ziozx4Unq9josNEJwB2VdM1Vox9isCJo
         yHjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688463997; x=1691055997;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4aSLqCS1Gj0I6/4Mma9xzM2KAL8Ih3WglTvqIOK6YZA=;
        b=XKQFJBAwn3r1TztOnTynLm170DClTrzitLslTlE7EATDgJyoXGnri27d5tBcGDPrhx
         ZiIFai+DiIwU5Jv0Do0wTaB1wghxI7tgOTRSlanEsSjEOFiifQwm3LzQTjMWUVhR2hlF
         MNr6NszPeFAEW7ldT7xehFFiNrtsMb1E661pVXNt9+BwIC42EKR1nn9E5vL/UuV6jXRm
         u9AldxzwJrLtWd0ITWL1T1/i3rqwF6focrxpDAm3ZrYy9bfBSl/obxL+8X44njeE5a13
         7UTHMx650t01Pa/MfFuG0U8pwdyk8qsgDzXR9mS9yywIE48WWxI5UZymHPE+p5cKf2hD
         IdCA==
X-Gm-Message-State: AC+VfDwH+4IXlWuxOKd4vwmD7OfGmWozvJoft4ERhUaOvFV8fz5jJejB
        GwUwsYv/Q8Jkz9WYRcRwF5V87bIpPDT1igbbxLs=
X-Google-Smtp-Source: ACHHUZ4e875urll8wF0znTi63D/om387JXmZFvJsjjZ53XF47YfmFmkHsPlxtulvD1Ai4BOZx4nxlA==
X-Received: by 2002:a1c:7203:0:b0:3fa:934c:8360 with SMTP id n3-20020a1c7203000000b003fa934c8360mr9896123wmc.8.1688463997008;
        Tue, 04 Jul 2023 02:46:37 -0700 (PDT)
Received: from myrica ([2.219.138.198])
        by smtp.gmail.com with ESMTPSA id v4-20020a05600c214400b003fa95890484sm24953698wml.20.2023.07.04.02.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jul 2023 02:46:36 -0700 (PDT)
Date:   Tue, 4 Jul 2023 10:46:36 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Suzuki.Poulose@arm.com, andre.przywara@arm.com, maz@kernel.org,
        oliver.upton@linux.dev, jean-philippe.brucker@arm.com,
        apatel@ventanamicro.com, kvm@vger.kernel.org
Subject: Re: [PATCH RESEND kvmtool 2/4] Replace printf/fprintf with pr_*
 macros
Message-ID: <20230704094636.GC3214657@myrica>
References: <20230630133134.65284-1-alexandru.elisei@arm.com>
 <20230630133134.65284-3-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230630133134.65284-3-alexandru.elisei@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 02:31:32PM +0100, Alexandru Elisei wrote:
> To prepare for allowing finer control over the messages that kvmtool
> displays, replace printf() and fprintf() with the pr_* macros.
> 
> Minor changes were made to fix coding style issues that were pet peeves for
> the author. And use pr_err() in kvm_cpu__init() instead of pr_warning() for
> fatal errors.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Looks good, some small things below

> ---
> I have my doubts about the change to kernel_usage_with_options(). I did
> this way instead of replacing fprintf() with pr_err() because this is how
> it would have looked like:
> 
>   Error: Could not find default kernel image in:
>   Error: 	./bzImage
>   Error: 	arch/arm64/boot/bzImage
>   Error: 	../../arch/arm64/boot/bzImage
>   Error: 	/boot/vmlinuz-6.4.0
>   Error: 	/boot/bzImage-6.4.0

Up to you but I'd leave it simple like that if it's just to print an
occasional error message, it looks alright to me.

> 
> And this is how it looks now:
> 
>   Error: Could not find default kernel image in:
> 	./bzImage
> 	arch/arm64/boot/bzImage
> 	../../arch/arm64/boot/bzImage
> 	/boot/vmlinuz-6.4.0
> 	/boot/bzImage-6.4.0
> 
> That, and msg ends up being 5 * 4096 ~= 20k bytes in size.
> Happy to come up with something else if this is not satisfactory.
> 
>  arm/gic.c       |  5 ++--
>  builtin-run.c   | 68 ++++++++++++++++++++++++++++++++++---------------
>  builtin-setup.c | 18 ++++++-------
>  guest_compat.c  |  2 +-
>  kvm-cpu.c       | 12 ++++-----
>  mmio.c          | 10 ++++----
>  virtio/core.c   |  6 ++---
>  x86/ioport.c    | 11 ++++----
>  8 files changed, 78 insertions(+), 54 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index a223a72cfeb9..0795e9509bf8 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -115,9 +115,8 @@ static int gic__create_its_frame(struct kvm *kvm, u64 its_frame_addr)
>  
>  	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &its_device);
>  	if (err) {
> -		fprintf(stderr,
> -			"GICv3 ITS requested, but kernel does not support it.\n");
> -		fprintf(stderr, "Try --irqchip=gicv3 instead\n");
> +		pr_err("GICv3 ITS requested, but kernel does not support it.");
> +		pr_err("Try --irqchip=gicv3 instead");
>  		return err;
>  	}
>  
> diff --git a/builtin-run.c b/builtin-run.c
> index bd0d0b9c2467..79d031777c26 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -271,12 +271,14 @@ static void *kvm_cpu_thread(void *arg)
>  	return (void *) (intptr_t) 0;
>  
>  panic_kvm:
> -	fprintf(stderr, "KVM exit reason: %u (\"%s\")\n",
> +	pr_err("KVM exit reason: %u (\"%s\")",
>  		current_kvm_cpu->kvm_run->exit_reason,
>  		kvm_exit_reasons[current_kvm_cpu->kvm_run->exit_reason]);
> -	if (current_kvm_cpu->kvm_run->exit_reason == KVM_EXIT_UNKNOWN)
> -		fprintf(stderr, "KVM exit code: 0x%llu\n",
> +
> +	if (current_kvm_cpu->kvm_run->exit_reason == KVM_EXIT_UNKNOWN) {
> +		pr_err("KVM exit code: 0x%llu",

Not your change but 0x%llu is wrong, it could be fixed here

>  			(unsigned long long)current_kvm_cpu->kvm_run->hw.hardware_exit_reason);
> +	}
>  
>  	kvm_cpu__set_debug_fd(STDOUT_FILENO);
>  	kvm_cpu__show_registers(current_kvm_cpu);
> @@ -310,28 +312,53 @@ static const char *default_vmlinux[] = {
>  
>  static void kernel_usage_with_options(void)
>  {
> -	const char **k;
> +	const char *prelude = "Could not find default kernel image in:";
>  	struct utsname uts;
> +	char *msg, *tmp;
> +	size_t msg_size;
> +	const char **k;
> +
> +	/* Ignore NULL path in host_kernels. */
> +	msg_size = PATH_MAX * (ARRAY_SIZE(host_kernels) - 1);
> +	msg_size += PATH_MAX * (ARRAY_SIZE(default_kernels) - 1);
> +	msg = calloc(msg_size, 1);
> +	if (!msg)
> +		die_perror("calloc");
> +	tmp = msg;
> +
> +	snprintf(tmp, msg_size, "%s\n", prelude);
> +	msg_size -= strlen(prelude) + 1;

msg_size didn't contain prelude

> +	tmp += strlen(prelude) + 1;
>  
> -	fprintf(stderr, "Fatal: could not find default kernel image in:\n");
>  	k = &default_kernels[0];
>  	while (*k) {
> -		fprintf(stderr, "\t%s\n", *k);
> +		if (snprintf(tmp, msg_size, "\t%s\n", *k) < 0)
> +			goto out;
> +		msg_size -= strlen(*k) + 2;
> +		tmp += strlen(*k) + 2;
>  		k++;
>  	}
>  
>  	if (uname(&uts) < 0)
> -		return;
> +		goto out;
>  
>  	k = &host_kernels[0];
>  	while (*k) {
>  		if (snprintf(kernel, PATH_MAX, "%s-%s", *k, uts.release) < 0)
> -			return;
> -		fprintf(stderr, "\t%s\n", kernel);
> +			goto out;
> +		if (snprintf(tmp, msg_size, "\t%s\n", kernel) < 0)
> +			goto out;
> +		msg_size -= strlen(kernel) + 2;
> +		tmp += strlen(kernel) + 2;
>  		k++;
>  	}
> -	fprintf(stderr, "\nPlease see '%s run --help' for more options.\n\n",
> +out:
> +	/* Remove trailing newline - pr_err() will add its own. */
> +	msg[strlen(msg) - 1] = '\0';
> +	pr_err("%s", msg);
> +	pr_info("Please see '%s run --help' for more options.",
>  		KVM_BINARY_NAME);
> +	free(msg);
>  }
>  
>  static u64 host_ram_size(void)
> @@ -656,8 +683,7 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
>  
>  			if ((kvm_run_wrapper == KVM_RUN_DEFAULT && kvm->cfg.kernel_filename) ||
>  				(kvm_run_wrapper == KVM_RUN_SANDBOX && kvm->cfg.sandbox)) {
> -				fprintf(stderr, "Cannot handle parameter: "
> -						"%s\n", argv[0]);
> +				pr_err("Cannot handle parameter: %s", argv[0]);
>  				usage_with_options(run_usage, options);
>  				free(kvm);
>  				return ERR_PTR(-EINVAL);
> @@ -775,15 +801,15 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
>  		kvm_run_set_real_cmdline(kvm);
>  
>  	if (kvm->cfg.kernel_filename) {
> -		printf("  # %s run -k %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
> -		       kvm->cfg.kernel_filename,
> -		       (unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
> -		       kvm->cfg.nrcpus, kvm->cfg.guest_name);
> +		pr_info("# %s run -k %s -m %Lu -c %d --name %s", KVM_BINARY_NAME,
> +			kvm->cfg.kernel_filename,
> +			(unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
> +			kvm->cfg.nrcpus, kvm->cfg.guest_name);
>  	} else if (kvm->cfg.firmware_filename) {
> -		printf("  # %s run --firmware %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
> -		       kvm->cfg.firmware_filename,
> -		       (unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
> -		       kvm->cfg.nrcpus, kvm->cfg.guest_name);
> +		pr_info("# %s run --firmware %s -m %Lu -c %d --name %s", KVM_BINARY_NAME,
> +			kvm->cfg.firmware_filename,
> +			(unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
> +			kvm->cfg.nrcpus, kvm->cfg.guest_name);
>  	}
>  
>  	if (init_list__init(kvm) < 0)
> @@ -815,7 +841,7 @@ static void kvm_cmd_run_exit(struct kvm *kvm, int guest_ret)
>  	init_list__exit(kvm);
>  
>  	if (guest_ret == 0)
> -		printf("\n  # KVM session ended normally.\n");
> +		pr_info("KVM session ended normally.");
>  }
>  
>  int kvm_cmd_run(int argc, const char **argv, const char *prefix)
> diff --git a/builtin-setup.c b/builtin-setup.c
> index b24d2a18921e..c333ae064b21 100644
> --- a/builtin-setup.c
> +++ b/builtin-setup.c
> @@ -271,15 +271,15 @@ int kvm_cmd_setup(int argc, const char **argv, const char *prefix)
>  		kvm_setup_help();
>  
>  	r = do_setup(instance_name);
> -	if (r == 0)
> -		printf("A new rootfs '%s' has been created in '%s%s'.\n\n"
> -			"You can now start it by running the following command:\n\n"
> -			"  %s run -d %s\n",
> -			instance_name, kvm__get_dir(), instance_name,
> -			KVM_BINARY_NAME,instance_name);
> -	else
> -		printf("Unable to create rootfs in %s%s: %s\n",
> -			kvm__get_dir(), instance_name, strerror(errno));
> +	if (r == 0) {
> +		pr_info("A new rootfs '%s' has been created in '%s%s'.",
> +			instance_name, kvm__get_dir(), instance_name);
> +		pr_info("You can now start it by running the following command:");
> +		pr_info("%s run -d %s", KVM_BINARY_NAME, instance_name);

Above uses '#' as prefix for a lkvm command, maybe we could keep it
consistent

> +	} else {
> +		pr_err("Unable to create rootfs in %s%s: %s",
> +		       kvm__get_dir(), instance_name, strerror(errno));
> +	}
>  
>  	return r;
>  }
> diff --git a/guest_compat.c b/guest_compat.c
> index fd4704b20b16..93f9aabcd6db 100644
> --- a/guest_compat.c
> +++ b/guest_compat.c
> @@ -86,7 +86,7 @@ int compat__print_all_messages(void)
>  
>  		msg = list_first_entry(&messages, struct compat_message, list);
>  
> -		printf("\n  # KVM compatibility warning.\n\t%s\n\t%s\n",
> +		pr_warning("KVM compatibility warning.\n\t%s\n\t%s",
>  			msg->title, msg->desc);
>  
>  		list_del(&msg->list);
> diff --git a/kvm-cpu.c b/kvm-cpu.c
> index 7dec08894cd3..1c566b3f21d6 100644
> --- a/kvm-cpu.c
> +++ b/kvm-cpu.c
> @@ -265,32 +265,32 @@ int kvm_cpu__init(struct kvm *kvm)
>  	recommended_cpus = kvm__recommended_cpus(kvm);
>  
>  	if (kvm->cfg.nrcpus > max_cpus) {
> -		printf("  # Limit the number of CPUs to %d\n", max_cpus);
> +		pr_warning("Limiting the number of CPUs to %d", max_cpus);
>  		kvm->cfg.nrcpus = max_cpus;
>  	} else if (kvm->cfg.nrcpus > recommended_cpus) {
> -		printf("  # Warning: The maximum recommended amount of VCPUs"
> -			" is %d\n", recommended_cpus);
> +		pr_warning("The maximum recommended amount of VCPUs is %d",
> +			   recommended_cpus);
>  	}
>  
>  	kvm->nrcpus = kvm->cfg.nrcpus;
>  
>  	task_eventfd = eventfd(0, 0);
>  	if (task_eventfd < 0) {
> -		pr_warning("Couldn't create task_eventfd");
> +		pr_err("Couldn't create task_eventfd");
>  		return task_eventfd;
>  	}
>  
>  	/* Alloc one pointer too many, so array ends up 0-terminated */
>  	kvm->cpus = calloc(kvm->nrcpus + 1, sizeof(void *));
>  	if (!kvm->cpus) {
> -		pr_warning("Couldn't allocate array for %d CPUs", kvm->nrcpus);
> +		pr_err("Couldn't allocate array for %d CPUs", kvm->nrcpus);
>  		return -ENOMEM;
>  	}
>  
>  	for (i = 0; i < kvm->nrcpus; i++) {
>  		kvm->cpus[i] = kvm_cpu__arch_init(kvm, i);
>  		if (!kvm->cpus[i]) {
> -			pr_warning("unable to initialize KVM VCPU");
> +			pr_err("unable to initialize KVM VCPU");
>  			goto fail_alloc;
>  		}
>  	}
> diff --git a/mmio.c b/mmio.c
> index 5a114e9997d9..d9a09565185c 100644
> --- a/mmio.c
> +++ b/mmio.c
> @@ -203,9 +203,9 @@ bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data,
>  	mmio = mmio_get(&mmio_tree, phys_addr, len);
>  	if (!mmio) {
>  		if (vcpu->kvm->cfg.mmio_debug)
> -			fprintf(stderr,	"Warning: Ignoring MMIO %s at %016llx (length %u)\n",
> -				to_direction(is_write),
> -				(unsigned long long)phys_addr, len);
> +			pr_warning("Warning: Ignoring MMIO %s at %016llx (length %u)",

"Warning:" is redundant

> +				   to_direction(is_write),
> +				   (unsigned long long)phys_addr, len);
>  		goto out;
>  	}
>  
> @@ -225,8 +225,8 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data,
>  	mmio = mmio_get(&pio_tree, port, size);
>  	if (!mmio) {
>  		if (vcpu->kvm->cfg.ioport_debug) {
> -			fprintf(stderr, "IO error: %s port=%x, size=%d, count=%u\n",
> -				to_direction(direction), port, size, count);
> +			pr_warning("IO error: %s port=%x, size=%d, count=%u",
> +				   to_direction(direction), port, size, count);
>  
>  			return false;
>  		}
> diff --git a/virtio/core.c b/virtio/core.c
> index a77e23bc9b34..c4e79c7a3d40 100644
> --- a/virtio/core.c
> +++ b/virtio/core.c
> @@ -417,10 +417,10 @@ int virtio_compat_add_message(const char *device, const char *config)
>  		return -ENOMEM;
>  	}
>  
> -	snprintf(title, len, "%s device was not detected.", device);
> -	snprintf(desc,  len, "While you have requested a %s device, "
> +	snprintf(title, len, "   %s device was not detected.", device);
> +	snprintf(desc,  len, "   While you have requested a %s device, "

Spaces seem redundant since there already is a \t prefix. I get this is to
align with "Warning:" but tab size can vary depending on the terminal.

>  			     "the guest kernel did not initialize it.\n"
> -			     "\tPlease make sure that the guest kernel was "
> +			     "\t   Please make sure that the guest kernel was "
>  			     "compiled with %s=y enabled in .config.",
>  			     device, config);
>  
> diff --git a/x86/ioport.c b/x86/ioport.c
> index 06b7defbaae8..0f1a857483c1 100644
> --- a/x86/ioport.c
> +++ b/x86/ioport.c
> @@ -14,9 +14,10 @@ static void debug_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
>  	if (!vcpu->kvm->cfg.ioport_debug)
>  		return;
>  
> -	fprintf(stderr, "debug port %s from VCPU%lu: port=0x%lx, size=%u",
> -		is_write ? "write" : "read", vcpu->cpu_id,
> -		(unsigned long)addr, len);
> +	pr_debug("debug port %s from VCPU%lu: port=0x%lx, size=%u",
> +		 is_write ? "write" : "read", vcpu->cpu_id,
> +		 (unsigned long)addr, len);
> +

This one is different: user enables ioport debugging with --debug-ioport
and expects to see these messages, even if loglevel < debug which is the
default. I think it should remain fprintf(). Though to be honest I don't
know if this is still supposed to work, currently kvm__emulate_io() exits
on the first ioport access when --debug-ioport is enabled.

Thanks,
Jean

>  	if (is_write) {
>  		u32 value;
>  
> @@ -26,9 +27,7 @@ static void debug_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
>  		case 4: value = ioport__read32((u32*)data); break;
>  		default: value = 0; break;
>  		}
> -		fprintf(stderr, ", data: 0x%x\n", value);
> -	} else {
> -		fprintf(stderr, "\n");
> +		pr_debug("data: 0x%x", value);
>  	}
>  }
>  
> -- 
> 2.41.0
> 
