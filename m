Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80F0407062
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 19:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhIJRRc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 13:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbhIJRRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 13:17:31 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45344C061756
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 10:16:20 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id dw14so906572pjb.1
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 10:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IKAooLF+vTfnieW2tIrxP2xffFZmpRGDjZ+89X8s+8Y=;
        b=svZWrjGmJxhtIPahOs5JtfQkZsLdoIHBQQe7QtsPgjKRnaOuthrfoY3hYe+6kQeTaR
         qX2k2pI+Vx71TroO6j4ZoKS2zZZI1hui/Vt7rwnbJpNG0xIXtLd94eerLw/HcbVJatj7
         3AYNlxTFbmCCROeipKYbxgoLFcfXFHdqMGqBIYoD1BwV46Rrox0h+RRUGveJvlmDH3gC
         XZjl36Zc+phoIQ2DTC1N8BYr5UDG34Elhjars6Hz2E/FwhEulYObPOQNnZNWw5vWw8q3
         7HNRFJG4j4g5NRZ93as5G2j0YB2ukvTlf7+BcJ9QFRPKfjG+V9S3S/Q0N4ZfllUg3O5j
         itpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IKAooLF+vTfnieW2tIrxP2xffFZmpRGDjZ+89X8s+8Y=;
        b=ZGuj5FFR0u9Ak0qyIcGfn4FZ+Y4XCWn+v1AjEwp6bnrIgqXogUoVK7IuVzhqCVe78x
         u+3N8HI113xQlHP2UD8AZ7vUQj2uE5beF8nRRRoUbN8QC9mQnQmCNCK5VF8Zu90aDoe9
         mO6B+G3Xm/8w5lZBa81BBZsww/YyxgAb2I68f54uWtpTEGehfvQDKDjoOuGse2F5J4Gu
         KjaKf7Ej/EXzDGPNfYP76DuQCKc5vkM68tadHga6ttXbg5czuaFQXF3cop7d5Q0/SH0E
         iX2CWBSHzFcusaF/ALzUtpfJ3sMvzM4CG7DI4oaOc+rN8nHHhYdAqOFjOjvPw4cZ//uq
         Htng==
X-Gm-Message-State: AOAM5318aTowgFwaExlEWmPxlkD2pEYZmAKdsMb/sSFhClFAwaXmE3q7
        SdX5+ZmL5bEVozQlROUNs45taw==
X-Google-Smtp-Source: ABdhPJz2atdWQoym0D7o9sVQ+uWyDRTmtDjMoEL97SzncG0HfQspC79csvCyy/k7E4IuHIY8QFoPFw==
X-Received: by 2002:a17:902:784f:b0:13a:3f0e:bb3f with SMTP id e15-20020a170902784f00b0013a3f0ebb3fmr8573110pln.61.1631294179442;
        Fri, 10 Sep 2021 10:16:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y2sm5735297pja.8.2021.09.10.10.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 10:16:18 -0700 (PDT)
Date:   Fri, 10 Sep 2021 17:16:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 V7] selftest: KVM: Add intra host migration tests
Message-ID: <YTuS3iHN7GgK4oQr@google.com>
References: <20210902181751.252227-1-pgonda@google.com>
 <20210902181751.252227-4-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902181751.252227-4-pgonda@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 02, 2021, Peter Gonda wrote:
> +/*
> + * Open SEV_DEV_PATH if available, otherwise exit the entire program.
> + *
> + * Input Args:
> + *   flags - The flags to pass when opening SEV_DEV_PATH.
> + *
> + * Return:
> + *   The opened file descriptor of /dev/sev.
> + */
> +static int open_sev_dev_path_or_exit(int flags)
> +{
> +	static int fd;
> +
> +	if (fd != 0)
> +		return fd;

Caching the file here is unnecessary, it's used in exactly one function.

> +	fd = open(SEV_DEV_PATH, flags);
> +	if (fd < 0) {
> +		print_skip("%s not available, is SEV not enabled? (errno: %d)",
> +			   SEV_DEV_PATH, errno);
> +		exit(KSFT_SKIP);
> +	}
> +
> +	return fd;
> +}

Rather than copy-paste _open_kvm_dev_path_or_exit(), it's probably worth factoring
out a helper in a separate patch, e.g.

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 10a8ed691c66..06a6c04010fb 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -31,6 +31,19 @@ static void *align(void *x, size_t size)
        return (void *) (((size_t) x + mask) & ~mask);
 }

+int open_path_or_exit(const char *path, int flags)
+{
+       int fd;
+
+       fd = open(path, flags);
+       if (fd < 0) {
+               print_skip("%s not available (errno: %d)", path, errno);
+               exit(KSFT_SKIP);
+       }
+
+       return fd;
+}
+
 /*
  * Open KVM_DEV_PATH if available, otherwise exit the entire program.
  *
@@ -42,16 +55,7 @@ static void *align(void *x, size_t size)
  */
 static int _open_kvm_dev_path_or_exit(int flags)
 {
-       int fd;
-
-       fd = open(KVM_DEV_PATH, flags);
-       if (fd < 0) {
-               print_skip("%s not available, is KVM loaded? (errno: %d)",
-                          KVM_DEV_PATH, errno);
-               exit(KSFT_SKIP);
-       }
-
-       return fd;
+       return open_path_or_exit(KVM_DEV_PATH, flags);
 }

 int open_kvm_dev_path_or_exit(void)


> +
> +static void sev_ioctl(int vm_fd, int cmd_id, void *data)
> +{
> +	struct kvm_sev_cmd cmd = {
> +		.id = cmd_id,
> +		.data = (uint64_t)data,
> +		.sev_fd = open_sev_dev_path_or_exit(0),
> +	};
> +	int ret;
> +
> +	TEST_ASSERT(cmd_id < KVM_SEV_NR_MAX && cmd_id >= 0,
> +		    "Unknown SEV CMD : %d\n", cmd_id);

LOL, I like sanity checks, but asserting that the test itself isn't horrendously 
broken is a bit much.  And someone manages to screw up that badly, the ioctl()
below will fail.

> +	ret = ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
> +	TEST_ASSERT((ret == 0 || cmd.error == SEV_RET_SUCCESS),
> +		    "%d failed: return code: %d, errno: %d, fw error: %d",
> +		    cmd_id, ret, errno, cmd.error);
> +}
> +
> +static struct kvm_vm *sev_vm_create(bool es)
> +{
> +	struct kvm_vm *vm;
> +	struct kvm_sev_launch_start start = { 0 };
> +	int i;

Rather than cache /dev/sev in a helper, you can do:

	int sev_fd = open_path_or_exit(SEV_DEV_PATH, 0);

	sev_ioctl(vm, sev_fd, ...);

> +	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
> +	sev_ioctl(vm->fd, es ? KVM_SEV_ES_INIT : KVM_SEV_INIT, NULL);
> +	for (i = 0; i < MIGRATE_TEST_NUM_VCPUS; ++i)
> +		vm_vcpu_add(vm, i);
> +	start.policy |= (es) << 2;

I had to go spelunking to confirm this is the "ES" policy, please do:

	if (es)
		start.policy |= SEV_POLICY_ES;

> +	sev_ioctl(vm->fd, KVM_SEV_LAUNCH_START, &start);
> +	if (es)
> +		sev_ioctl(vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);


And with sev_fd scoped to this function:

	close(sev_fd);

which I think is legal?

> +	return vm;
> +}
> +
> +static void test_sev_migrate_from(bool es)
> +{
> +	struct kvm_vm *vms[MIGRATE_TEST_VMS];

Prefix this and LOCK_TESTING_THREAD with NR_ so that it's clear these are arbitrary
numbers of things.  And I guess s/MIGRATE_TEST_NUM_VCPUS/NR_MIGRATE_TEST_VCPUS to
be consistent.

> +	struct kvm_enable_cap cap = {
> +		.cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM
> +	};
> +	int i;
> +
> +	for (i = 0; i < MIGRATE_TEST_VMS; ++i) {
> +		vms[i] = sev_vm_create(es);

It doesn't really matter, but closing these fds tests that KVM doesn't explode
when VMs are destroyed without the process exiting.

> +		if (i > 0) {
> +			cap.args[0] = vms[i - 1]->fd;
> +			vm_enable_cap(vms[i], &cap);
> +		}
> +	}

For giggles, we can also test migrating back (with some feedback from below
mixed in):

	/* Initial migration from the src to the first dst. */
	sev_migrate_from(dst_vms[0]->fd, src_vm->fd);

	for (i = 1; i < NR_MIGRATE_TEST_VMS; i++)
		sev_migrate_from(vms[i]->fd, vms[i - 1]->fd);

	/* Migrate the guest back to the original VM. */
	sev_migrate_from(src_vm->fd, dst_vms[NR_MIGRATE_TEST_VMS - 1]->fd);

> +}
> +
> +struct locking_thread_input {
> +	struct kvm_vm *vm;
> +	int source_fds[LOCK_TESTING_THREADS];
> +};
> +
> +static void *locking_test_thread(void *arg)
> +{
> +	/*
> +	 * This test case runs a number of threads all trying to use the intra
> +	 * host migration ioctls. This tries to detect if a deadlock exists.
> +	 */
> +	struct kvm_enable_cap cap = {
> +		.cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM
> +	};
> +	int i, j;
> +	struct locking_thread_input *input = (struct locking_test_thread *)arg;
> +
> +	for (i = 0; i < LOCK_TESTING_ITERATIONS; ++i) {
> +		j = input->source_fds[i % LOCK_TESTING_THREADS];
> +		cap.args[0] = input->source_fds[j];

This looks wrong, it's indexing source_fds with a value from source_fds.  Did
you intend?

		j = i % LOCK_TESTING_THREADS;
		cap.args[0] = input->source_fds[j];

> +		/*
> +		 * Call IOCTL directly without checking return code or
> +		 * asserting. We are * simply trying to confirm there is no
> +		 * deadlock from userspace * not check correctness of
> +		 * migration here.
> +		 */
> +		ioctl(input->vm->fd, KVM_ENABLE_CAP, &cap);

For readability and future extensibility, I'd say create a single helper and use
it even in the happy case, e.g.

static int __sev_migrate_from(int dst_fd, int src_fd)
{
	struct kvm_enable_cap cap = {
		.cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM,
		.args = { src_fd } // No idea if this is correct syntax
	};

	return ioctl(dst_fd, KVM_ENABLE_CAP, &cap);
}


static void sev_migrate_from(...)
{
	ret = __sev_migrate_from(...);
	TEST_ASSERT(!ret, "Migration failed, blah blah blah");
}

> +	}
> +}
> +
> +static void test_sev_migrate_locking(void)
> +{
> +	struct locking_thread_input input[LOCK_TESTING_THREADS];
> +	pthread_t pt[LOCK_TESTING_THREADS];
> +	int i;
> +
> +	for (i = 0; i < LOCK_TESTING_THREADS; ++i) {

With a bit of refactoring, the same VMs from the happy case can be reused for
the locking test, and we can also get concurrent SEV+SEV-ES migration (see below).

> +		input[i].vm = sev_vm_create(/* es= */ false);
> +		input[0].source_fds[i] = input[i].vm->fd;
> +	}
> +	for (i = 1; i < LOCK_TESTING_THREADS; ++i)
> +		memcpy(input[i].source_fds, input[0].source_fds,
> +		       sizeof(input[i].source_fds));
> +
> +	for (i = 0; i < LOCK_TESTING_THREADS; ++i)
> +		pthread_create(&pt[i], NULL, locking_test_thread, &input[i]);
> +
> +	for (i = 0; i < LOCK_TESTING_THREADS; ++i)
> +		pthread_join(pt[i], NULL);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	test_sev_migrate_from(/* es= */ false);
> +	test_sev_migrate_from(/* es= */ true);
> +	test_sev_migrate_locking();


With a little refactoring, this can add other tests, e.g. illegal dst.  Assuming
KVM requires the dst to be !SEV, SEV and SEV-ES can use the same set of destination
VMs.  And the locking test can take 'em all.  E.g. something like:

	struct kvm_vm *sev_vm, *sev_es_vm;

	sev_vm = sev_vm_create(false);
	sev_es_vm = sev_vm_create(true);

	for (i = 0; i < NR_MIGRATE_TEST_VMS; i++)
		dst_vms[i] = sev_dst_vm_create();

	test_sev_migrate_from(sev_vms, dst_vms);
	test_sev_migrate_from(sev_es_vms, dst_vms);

	ret = __sev_migrate_from(sev_es_vms[0], sev_vms[0]);
	TEST_ASSERT(ret == -EINVAL, ...);

	ret = __sev_migrate_from(sev_vms[0], sev_es_vms[0]);
	TEST_ASSERT(ret == -EINVAL, ...);
	
	ret = __sev_migrate_from(dst_vms[0], dst_vms[1]);
	TEST_ASSERT(ret == -EINVAL, ....);

	test_sev_migrate_locking(sev_vm, sev_es_vm, dst_vms);

> +	return 0;
> +}
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 
