Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00F874CFEB
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 10:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjGJIas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 04:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjGJIaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 04:30:46 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17579E2
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 01:30:45 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3fb4146e8ceso44169835e9.0
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 01:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688977843; x=1691569843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6a3i4GqhC/i9SwLMO2WBT7RUOFRfDqi5pIIsqhiRIBw=;
        b=Rb1K2s/ui4HWhWUqtNXK0qbJhzwo86++Ky8b++7p1dwAiOFMGh9zLED+PFvFY8tPac
         LPERM8uUDkc6dkNaAIo9BqgeB+W6ArBOnyACzqSGlho+1kFKQbLQiW0X3zO5+tbTqatk
         G32vH7p9ACCiU5ZP4zeY4/E0vTgsJ3RnatIrhZLeUvEE/nJPONfZCQ2ZSolFDbWgU4Sy
         T82/PXlQCyH1maJ73DkXy6L8MiQXgCo1TKKJiD3VmqO11ZokOZTG6/6Ff9MNGvdMSpZk
         TY1Lde7hf1QtTJTqUXY0eLqF+AzToThvvshMj6s6vWkLnhAXuwjmUFKZRs9cLKNMW8cP
         kJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688977843; x=1691569843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6a3i4GqhC/i9SwLMO2WBT7RUOFRfDqi5pIIsqhiRIBw=;
        b=jbvzWr1tNB2MdzlIUcWft5qokrm5M75bV6D0UYHcI7r7YzcX9uI/VqOUd5ltAsgk0d
         wajxSbPnMzF14R647UneFOPJ/QUA10twUnWj6cR3s3GP000URQqIGvi8QTa7hA6RWA1j
         4CxOYuFnt4/7oA/ONOSAb0BkXVzol+z77pcYiHmotsQIhoRUA6G8evgYXoPzNyukgLNh
         xPzbzkyu7UcAROvp1UHdtFuWika9XenZmpHM9C02fsGYlVs6CeoU/3rc1yABU8Oe4avB
         mKNIwI64ZDoC/KjzWp5MbaeQARaC6nluswctRIEgH599nC44vn7GMwTfCgRZNLv6uFsR
         IwOg==
X-Gm-Message-State: ABy/qLYOIoPLXL4k7QIqIcffS6lUem1pPlxz1MX7D8jcJfDK3sh4K7z3
        nIPD6s2IMUu7iTeQ5iwgHJxMzA==
X-Google-Smtp-Source: APBJJlHXMMmitwtRxZXf0RFOIvJouKJIlA/IrSPBX3MDOnYEf4QkPMmaSbrbSdOE6IVwclu2ahgeZw==
X-Received: by 2002:a05:600c:2058:b0:3fb:c417:5e6 with SMTP id p24-20020a05600c205800b003fbc41705e6mr7539248wmg.23.1688977843332;
        Mon, 10 Jul 2023 01:30:43 -0700 (PDT)
Received: from myrica ([2.219.138.198])
        by smtp.gmail.com with ESMTPSA id y11-20020a05600c364b00b003f90b9b2c31sm9635096wmq.28.2023.07.10.01.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jul 2023 01:30:42 -0700 (PDT)
Date:   Mon, 10 Jul 2023 09:30:42 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Suzuki.Poulose@arm.com, andre.przywara@arm.com, maz@kernel.org,
        oliver.upton@linux.dev, jean-philippe.brucker@arm.com,
        apatel@ventanamicro.com, kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool v2 2/4] Replace printf/fprintf with pr_* macros
Message-ID: <20230710083042.GA112663@myrica>
References: <20230707151119.81208-1-alexandru.elisei@arm.com>
 <20230707151119.81208-3-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230707151119.81208-3-alexandru.elisei@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 07, 2023 at 04:11:17PM +0100, Alexandru Elisei wrote:
> To prepare for allowing finer control over the messages that kvmtool
> displays, replace printf() and fprintf() with the pr_* macros.
> 
> Minor changes were made to fix coding style issues that were pet peeves for
> the author. And use pr_err() in kvm_cpu__init() instead of pr_warning() for
> fatal errors.
> 
> Also, fix the message when printing the exit code for KVM_EXIT_UNKNOWN by
> removing the '0x' part, because it's printing a decimal number, not a
> hexadecimal one (the format specifier is %llu, not %llx).
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

> ---
> Changelog:
> 
> - Use pr_err() to directly replace fprintf() in kernel_usage_with_options()
>   instead of concatening the kernel locations.
> - Removed the '0x' from the "KVM exit code: 0x%llu" message in kvm_cpu_thread()
>   because the number is decimal (it's %llu, not %llx).
> - Reverted the changes to kvm__emulate_mmio() and debug_io () because those
>   messages are displayed with --debug-mmio, respectively --debug-ioport, and
>   --loglevel hiding them would have been counter-intuitive.
> - Replaced the "warning" string in kvm__emulate_mmio() with "MMIO warning", to
>   match the message from kvm__emulate_io(). And to make it clear that it isn't
>   toggled with --loglevel.
> - Removed extra spaces in virtio_compat_add_message().
> 
>  arm/gic.c       |  5 ++---
>  builtin-run.c   | 37 +++++++++++++++++++------------------
>  builtin-setup.c | 16 ++++++++--------
>  guest_compat.c  |  2 +-
>  kvm-cpu.c       | 12 ++++++------
>  mmio.c          |  2 +-
>  6 files changed, 37 insertions(+), 37 deletions(-)
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
> index bd0d0b9c2467..190a226e46da 100644
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
> +		pr_err("KVM exit code: %llu",
>  			(unsigned long long)current_kvm_cpu->kvm_run->hw.hardware_exit_reason);
> +	}
>  
>  	kvm_cpu__set_debug_fd(STDOUT_FILENO);
>  	kvm_cpu__show_registers(current_kvm_cpu);
> @@ -313,10 +315,10 @@ static void kernel_usage_with_options(void)
>  	const char **k;
>  	struct utsname uts;
>  
> -	fprintf(stderr, "Fatal: could not find default kernel image in:\n");
> +	pr_err("Could not find default kernel image in:");
>  	k = &default_kernels[0];
>  	while (*k) {
> -		fprintf(stderr, "\t%s\n", *k);
> +		pr_err("\t%s", *k);
>  		k++;
>  	}
>  
> @@ -327,10 +329,10 @@ static void kernel_usage_with_options(void)
>  	while (*k) {
>  		if (snprintf(kernel, PATH_MAX, "%s-%s", *k, uts.release) < 0)
>  			return;
> -		fprintf(stderr, "\t%s\n", kernel);
> +		pr_err("\t%s", kernel);
>  		k++;
>  	}
> -	fprintf(stderr, "\nPlease see '%s run --help' for more options.\n\n",
> +	pr_info("Please see '%s run --help' for more options.",
>  		KVM_BINARY_NAME);
>  }
>  
> @@ -656,8 +658,7 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
>  
>  			if ((kvm_run_wrapper == KVM_RUN_DEFAULT && kvm->cfg.kernel_filename) ||
>  				(kvm_run_wrapper == KVM_RUN_SANDBOX && kvm->cfg.sandbox)) {
> -				fprintf(stderr, "Cannot handle parameter: "
> -						"%s\n", argv[0]);
> +				pr_err("Cannot handle parameter: %s", argv[0]);
>  				usage_with_options(run_usage, options);
>  				free(kvm);
>  				return ERR_PTR(-EINVAL);
> @@ -775,15 +776,15 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
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
> @@ -815,7 +816,7 @@ static void kvm_cmd_run_exit(struct kvm *kvm, int guest_ret)
>  	init_list__exit(kvm);
>  
>  	if (guest_ret == 0)
> -		printf("\n  # KVM session ended normally.\n");
> +		pr_info("KVM session ended normally.");
>  }
>  
>  int kvm_cmd_run(int argc, const char **argv, const char *prefix)
> diff --git a/builtin-setup.c b/builtin-setup.c
> index b24d2a18921e..27b641982359 100644
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
> +	if (r == 0) {
> +		pr_info("A new rootfs '%s' has been created in '%s%s'.",
> +			instance_name, kvm__get_dir(), instance_name);
> +		pr_info("You can now start it by running the following command:");
> +		pr_info("%s run -d %s", KVM_BINARY_NAME, instance_name);
> +	} else {
> +		pr_err("Unable to create rootfs in %s%s: %s",
>  			kvm__get_dir(), instance_name, strerror(errno));
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
> index 5a114e9997d9..231ce91e3d47 100644
> --- a/mmio.c
> +++ b/mmio.c
> @@ -203,7 +203,7 @@ bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data,
>  	mmio = mmio_get(&mmio_tree, phys_addr, len);
>  	if (!mmio) {
>  		if (vcpu->kvm->cfg.mmio_debug)
> -			fprintf(stderr,	"Warning: Ignoring MMIO %s at %016llx (length %u)\n",
> +			fprintf(stderr,	"MMIO warning: Ignoring MMIO %s at %016llx (length %u)\n",
>  				to_direction(is_write),
>  				(unsigned long long)phys_addr, len);
>  		goto out;
> -- 
> 2.41.0
> 
