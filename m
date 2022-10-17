Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF4D60137C
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 18:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiJQQc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 12:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiJQQc5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 12:32:57 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A3F2BCA
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:32:55 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id j4so18434241lfk.0
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G+NNDBimJt6iuNVKZWTKNAygMVDxh+MmfNb6Pvu89mM=;
        b=jqIpXUutzBroBLsBPqFpFNHIETNkF4VBS5xSmyqGesst1d2puspWlJRGIXD0WSQbHv
         KHhcmQvRKuomtxCxCc+mEcWoPtrMr8DI9g+mXOhTOiP52LMRCGNREfVin2ZjnzUSW567
         8QOHFNcHsEsNzfXWeerA+VBkcWjqxmk34CjYWYUAJ9kisgYBlguDJQImKCgNB4z7cnZ9
         eVgI98JoQPgExFsE85/yDzUFOJi59Tm6olBy/0ltAyFiV8RYBgJ8ANiLPdhX1nwrhTtH
         nu8uENMZWCf8+3CtDGY//4qN6CHEhCokO5rbYlJ2FfMRoxGqqTb/v33GAZ/4OsYG0kZX
         lqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G+NNDBimJt6iuNVKZWTKNAygMVDxh+MmfNb6Pvu89mM=;
        b=BZ+mjAOz1I73HNjLWRN/R3bbaq5XTJ9hyak4v2mlmNBGMYkPhY4pjNqfdZF4l1B9BA
         hOZxUPQ1xmaoGKKnngpUdBndWL1DlQcZ4KVbIFkn6BiXlG3nKuxtDmKjR9SuL3K7TO/K
         uIEri8n1YEzBM1an9nJAJlsmhqhKem5wvvm0tpEBfTAwjM0V87l61gODnxrIomoZrqP3
         mO0hDoa4DwUooQ2kEmO2Zuv6gf5E57cRfbInIYx3aNcZpG2QyX7lrXHsFidTT18ye7VC
         nUUGBc+29pc6TGvBycbtAA8byXpQILomzA7yzt61PPg0s+E4SAgXt8AIQHP5BNYk4T3T
         QLHw==
X-Gm-Message-State: ACrzQf3/YEeGK71fSjx1rXgogXHqm0xa+vIqOQl+SND9WhvDZC7qRPOl
        rULN45V4tMWogqrqh9t+7uUD5kMJeoAQ7ZyoM604Sw==
X-Google-Smtp-Source: AMsMyM7ePTv77sEaro3RsDVe6c8dX0ljwdugOpwh4TdimBQERnam8DtyJF5BC5WX+q2SH92VwzpFr0Vv4hBHiD8hCy4=
X-Received: by 2002:a05:6512:12c4:b0:4a2:5598:f6a2 with SMTP id
 p4-20020a05651212c400b004a25598f6a2mr4083606lfg.409.1666024373216; Mon, 17
 Oct 2022 09:32:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220829171021.701198-1-pgonda@google.com> <20220829171021.701198-7-pgonda@google.com>
 <Yz8dpB5+RFjEhA3n@google.com>
In-Reply-To: <Yz8dpB5+RFjEhA3n@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 17 Oct 2022 10:32:41 -0600
Message-ID: <CAMkAt6oZQc4jqF7FOXOKkpbP3c4NXxPumVVjX9gXwPCh-zbtYg@mail.gmail.com>
Subject: Re: [V4 6/8] KVM: selftests: add library for creating/interacting
 with SEV guests
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 6, 2022 at 12:25 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Aug 29, 2022, Peter Gonda wrote:
> > Add interfaces to allow tests to create/manage SEV guests. The
> > additional state associated with these guests is encapsulated in a new
> > struct sev_vm, which is a light wrapper around struct kvm_vm. These
> > VMs will use vm_set_memory_encryption() and vm_get_encrypted_phy_pages()
> > under the covers to configure and sync up with the core kvm_util
> > library on what should/shouldn't be treated as encrypted memory.
> >
> > Originally-by: Michael Roth <michael.roth@amd.com>
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../selftests/kvm/include/kvm_util_base.h     |   3 +
> >  .../selftests/kvm/include/x86_64/sev.h        |  47 ++++
> >  tools/testing/selftests/kvm/lib/x86_64/sev.c  | 232 ++++++++++++++++++
> >  4 files changed, 283 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
> >  create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 23649c5d42fc..0a70e50f0498 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -56,6 +56,7 @@ LIBKVM_x86_64 += lib/x86_64/processor.c
> >  LIBKVM_x86_64 += lib/x86_64/svm.c
> >  LIBKVM_x86_64 += lib/x86_64/ucall.c
> >  LIBKVM_x86_64 += lib/x86_64/vmx.c
> > +LIBKVM_x86_64 += lib/x86_64/sev.c
> >
> >  LIBKVM_aarch64 += lib/aarch64/gic.c
> >  LIBKVM_aarch64 += lib/aarch64/gic_v3.c
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index 489e8c833e5f..0927e262623d 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -69,6 +69,7 @@ struct userspace_mem_regions {
> >  /* Memory encryption policy/configuration. */
> >  struct vm_memcrypt {
> >       bool enabled;
> > +     bool encrypted;
> >       int8_t enc_by_default;
> >       bool has_enc_bit;
> >       int8_t enc_bit;
> > @@ -831,6 +832,8 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
> >
> >  static inline vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
> >  {
> > +     TEST_ASSERT(!vm->memcrypt.encrypted,
>
> vm->protected
>
> > +                 "Encrypted guests have their page tables encrypted so gva2gpa conversions are not possible.");
>
> Unnecessarily verbose, e.g.
>
>                     "Protected VMs have private, inaccessible page tables");
>
> > +#define CPUID_MEM_ENC_LEAF 0x8000001f
> > +#define CPUID_EBX_CBIT_MASK 0x3f
> > +
> > +/* Common SEV helpers/accessors. */
>
> Please drop this comment and the "Local helpers" and "SEV VM implementation" comments
> below.  There's 0% chance these comments will stay fresh as code is added and moved
> around.  They also add no value IMO, e.g. "static" makes it quite obvious it's a
> local function, and sev_* vs. sev_es_*. vs. sev_snp_* namespacing takes care of the
> rest.
>
> > +void sev_ioctl(int sev_fd, int cmd, void *data)
> > +{
> > +     int ret;
> > +     struct sev_issue_cmd arg;
> > +
> > +     arg.cmd = cmd;
> > +     arg.data = (unsigned long)data;
> > +     ret = ioctl(sev_fd, SEV_ISSUE_CMD, &arg);
> > +     TEST_ASSERT(ret == 0,
> > +                 "SEV ioctl %d failed, error: %d, fw_error: %d",
> > +                 cmd, ret, arg.error);
> > +}
> > +
> > +void kvm_sev_ioctl(struct sev_vm *sev, int cmd, void *data)
> > +{
> > +     struct kvm_sev_cmd arg = {0};
> > +     int ret;
> > +
> > +     arg.id = cmd;
> > +     arg.sev_fd = sev->fd;
> > +     arg.data = (__u64)data;
> > +
> > +     ret = ioctl(sev->vm->fd, KVM_MEMORY_ENCRYPT_OP, &arg);
> > +     TEST_ASSERT(ret == 0,
> > +                 "SEV KVM ioctl %d failed, rc: %i errno: %i (%s), fw_error: %d",
> > +                 cmd, ret, errno, strerror(errno), arg.error);
> > +}
> > +
> > +/* Local helpers. */
> > +
> > +static void sev_register_user_region(struct sev_vm *sev, void *hva, uint64_t size)
> > +{
> > +     struct kvm_enc_region range = {0};
> > +     int ret;
> > +
> > +     pr_debug("%s: hva: %p, size: %lu\n", __func__, hva, size);
> > +
> > +     range.addr = (__u64)hva;
> > +     range.size = size;
> > +
> > +     ret = ioctl(sev->vm->fd, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
> > +     TEST_ASSERT(ret == 0, "failed to register user range, errno: %i\n", errno);
> > +}
> > +
> > +static void sev_encrypt_phy_range(struct sev_vm *sev, vm_paddr_t gpa, uint64_t size)
> > +{
> > +     struct kvm_sev_launch_update_data ksev_update_data = {0};
> > +
> > +     pr_debug("%s: addr: 0x%lx, size: %lu\n", __func__, gpa, size);
> > +
> > +     ksev_update_data.uaddr = (__u64)addr_gpa2hva(sev->vm, gpa);
> > +     ksev_update_data.len = size;
> > +
> > +     kvm_sev_ioctl(sev, KVM_SEV_LAUNCH_UPDATE_DATA, &ksev_update_data);
> > +}
> > +
> > +static void sev_encrypt(struct sev_vm *sev)
> > +{
> > +     const struct sparsebit *enc_phy_pages;
> > +     struct kvm_vm *vm = sev->vm;
> > +     sparsebit_idx_t pg = 0;
> > +     vm_paddr_t gpa_start;
> > +     uint64_t memory_size;
> > +     int ctr;
> > +     struct userspace_mem_region *region;
> > +
> > +     hash_for_each(vm->regions.slot_hash, ctr, region, slot_node) {
> > +             enc_phy_pages = vm_get_encrypted_phy_pages(
>
> Please don't wrap after the opening paranthesis unless it's really, really necessary.
> More for future reference since I think vm_get_encrypted_phy_pages() should be open
> coded here.  E.g. in this case, the "enc_phy_" prefix doesn't add much value, and
> dropping that makes the code easier to read overall.
>
>                 pages = vm_get_encrypted_phy_pages(sev->vm, region->region.slot,
>                                                    &gpa_start, &memory_size);
>
> > +                     sev->vm, region->region.slot, &gpa_start, &memory_size);
> > +             TEST_ASSERT(enc_phy_pages,
> > +                         "Unable to retrieve encrypted pages bitmap");
> > +             while (pg < (memory_size / vm->page_size)) {
> > +                     sparsebit_idx_t pg_cnt;
>
> s/pg_cnt/nr_pages
>
> > +
> > +                     if (sparsebit_is_clear(enc_phy_pages, pg)) {
> > +                             pg = sparsebit_next_set(enc_phy_pages, pg);
> > +                             if (!pg)
> > +                                     break;
> > +                     }
> > +
> > +                     pg_cnt = sparsebit_next_clear(enc_phy_pages, pg) - pg;
> > +                     if (pg_cnt <= 0)
> > +                             pg_cnt = 1;
> > +
> > +                     sev_encrypt_phy_range(sev,
> > +                                           gpa_start + pg * vm->page_size,
> > +                                           pg_cnt * vm->page_size);
> > +                     pg += pg_cnt;
> > +             }
> > +     }
> > +
> > +     sev->vm->memcrypt.encrypted = true;
> > +}
> > +
> > +/* SEV VM implementation. */
> > +
> > +static struct sev_vm *sev_vm_alloc(struct kvm_vm *vm)
> > +{
> > +     struct sev_user_data_status sev_status;
> > +     uint32_t eax, ebx, ecx, edx;
> > +     struct sev_vm *sev;
> > +     int sev_fd;
> > +
> > +     sev_fd = open(SEV_DEV_PATH, O_RDWR);
> > +     if (sev_fd < 0) {
> > +             pr_info("Failed to open SEV device, path: %s, error: %d, skipping test.\n",
> > +                     SEV_DEV_PATH, sev_fd);
> > +             return NULL;
>
> Printing "skipping test" is wrong as there's no guarantee the caller is going to
> skip the test.  E.g. the sole user in this series asserts, i.e. fails the test.
>
> I also think that waiting until VM allocation to perform these sanity checks is
> flawed.  Rather do these checks every time, add helpers to query SEV and SEV-ES
> support, and then use TEST_REQUIRE() to actually skip tests that require support,
> e.g.
>
>         TEST_REQUIRE(kvm_is_sev_supported());
>
> or
>
>         TEST_REQUIRE(kvm_is_sev_es_supported());
>
> Then this helper can simply assert that opening SEV_DEV_PATH succeeds.
>
> > +     }
> > +
> > +     sev_ioctl(sev_fd, SEV_PLATFORM_STATUS, &sev_status);
> > +
> > +     if (!(sev_status.api_major > SEV_FW_REQ_VER_MAJOR ||
> > +           (sev_status.api_major == SEV_FW_REQ_VER_MAJOR &&
> > +            sev_status.api_minor >= SEV_FW_REQ_VER_MINOR))) {
> > +             pr_info("SEV FW version too old. Have API %d.%d (build: %d), need %d.%d, skipping test.\n",
> > +                     sev_status.api_major, sev_status.api_minor, sev_status.build,
> > +                     SEV_FW_REQ_VER_MAJOR, SEV_FW_REQ_VER_MINOR);
> > +             return NULL;
> > +     }
> > +
> > +     sev = calloc(1, sizeof(*sev));
>
> TEST_ASSERT(sev, ...)
>
> > +     sev->fd = sev_fd;
> > +     sev->vm = vm;
> > +
> > +     /* Get encryption bit via CPUID. */
> > +     cpuid(CPUID_MEM_ENC_LEAF, &eax, &ebx, &ecx, &edx);
> > +     sev->enc_bit = ebx & CPUID_EBX_CBIT_MASK;
>
> Oh hey, another series of mine[*] that you can leverage :-)
>
> [*] https://lore.kernel.org/all/20221006005125.680782-1-seanjc@google.com
>
> > +
> > +     return sev;
> > +}
> > +
> > +void sev_vm_free(struct sev_vm *sev)
> > +{
> > +     kvm_vm_free(sev->vm);
> > +     close(sev->fd);
> > +     free(sev);
> > +}
> > +
> > +struct sev_vm *sev_vm_create(uint32_t policy, uint64_t npages)
>
> The migration test already defines sev_vm_create().  That conflict needs to be
> resolved.
>
> > +{
> > +     struct sev_vm *sev;
> > +     struct kvm_vm *vm;
> > +
> > +     /* Need to handle memslots after init, and after setting memcrypt. */
> > +     vm = vm_create_barebones();
>
> Do not use vm_create_barebones().  That API is only to be used for tests that do
> not intend to run vCPUs.
>
>
>
> > +     sev = sev_vm_alloc(vm);
> > +     if (!sev)
> > +             return NULL;
> > +     sev->sev_policy = policy;
> > +
> > +     kvm_sev_ioctl(sev, KVM_SEV_INIT, NULL);
> > +
> > +     vm->vpages_mapped = sparsebit_alloc();
>
> This is unnecessary and leaks memory, vm->vpages_mapped is allocated by
> ____vm_create().
>
> > +     vm_set_memory_encryption(vm, true, true, sev->enc_bit);
> > +     pr_info("SEV cbit: %d\n", sev->enc_bit);
> > +     vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, npages, 0);
> > +     sev_register_user_region(sev, addr_gpa2hva(vm, 0),
> > +                              npages * vm->page_size);
>
> Burying sev_register_user_region() in here is not going to be maintainble.  I
> think the best away to handle this is to add an arch hook in vm_userspace_mem_region_add()
> and automatically register regions when they're created.
>
> And with that, I believe sev_vm_create() can go away entirely and the SEV encryption
> stuff can be handled via a new vm_guest_mode.  ____vm_create() already has a gross
> __x86_64__ hook that we can tweak, e.g.
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 54b8d8825f5d..2d6cbca2c01a 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -238,9 +238,10 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
>         case VM_MODE_P36V47_16K:
>                 vm->pgtable_levels = 3;
>                 break;
> +       case VM_MODE_PXXV48_4K_SEV:
>         case VM_MODE_PXXV48_4K:
>  #ifdef __x86_64__
> -               kvm_get_cpu_address_width(&vm->pa_bits, &vm->va_bits);
> +               kvm_init_vm_address_properties(vm);
>                 /*
>                  * Ignore KVM support for 5-level paging (vm->va_bits == 57),
>                  * it doesn't take effect unless a CR4.LA57 is set, which it
>
> Then kvm_init_vm_address_properties() can pivot on vm->mode to deal with SEV
> specific stuff.
>
> > +
> > +     pr_info("SEV guest created, policy: 0x%x, size: %lu KB\n",
> > +             sev->sev_policy, npages * vm->page_size / 1024);
> > +
> > +     return sev;
> > +}
> > +
> > +void sev_vm_launch(struct sev_vm *sev)
> > +{
> > +     struct kvm_sev_launch_start ksev_launch_start = {0};
> > +     struct kvm_sev_guest_status ksev_status;
> > +
> > +     ksev_launch_start.policy = sev->sev_policy;
> > +     kvm_sev_ioctl(sev, KVM_SEV_LAUNCH_START, &ksev_launch_start);
> > +     kvm_sev_ioctl(sev, KVM_SEV_GUEST_STATUS, &ksev_status);
> > +     TEST_ASSERT(ksev_status.policy == sev->sev_policy, "Incorrect guest policy.");
> > +     TEST_ASSERT(ksev_status.state == SEV_GSTATE_LUPDATE,
> > +                 "Unexpected guest state: %d", ksev_status.state);
> > +
> > +     ucall_init(sev->vm, 0);
> > +
> > +     sev_encrypt(sev);
> > +}
> > +
> > +void sev_vm_launch_measure(struct sev_vm *sev, uint8_t *measurement)
> > +{
> > +     struct kvm_sev_launch_measure ksev_launch_measure;
> > +     struct kvm_sev_guest_status ksev_guest_status;
> > +
> > +     ksev_launch_measure.len = 256;
> > +     ksev_launch_measure.uaddr = (__u64)measurement;
> > +     kvm_sev_ioctl(sev, KVM_SEV_LAUNCH_MEASURE, &ksev_launch_measure);
> > +
> > +     /* Measurement causes a state transition, check that. */
> > +     kvm_sev_ioctl(sev, KVM_SEV_GUEST_STATUS, &ksev_guest_status);
> > +     TEST_ASSERT(ksev_guest_status.state == SEV_GSTATE_LSECRET,
> > +                 "Unexpected guest state: %d", ksev_guest_status.state);
> > +}
> > +
> > +void sev_vm_launch_finish(struct sev_vm *sev)
> > +{
> > +     struct kvm_sev_guest_status ksev_status;
> > +
> > +     kvm_sev_ioctl(sev, KVM_SEV_GUEST_STATUS, &ksev_status);
> > +     TEST_ASSERT(ksev_status.state == SEV_GSTATE_LUPDATE ||
> > +                 ksev_status.state == SEV_GSTATE_LSECRET,
> > +                 "Unexpected guest state: %d", ksev_status.state);
> > +
> > +     kvm_sev_ioctl(sev, KVM_SEV_LAUNCH_FINISH, NULL);
> > +
> > +     kvm_sev_ioctl(sev, KVM_SEV_GUEST_STATUS, &ksev_status);
> > +     TEST_ASSERT(ksev_status.state == SEV_GSTATE_RUNNING,
> > +                 "Unexpected guest state: %d", ksev_status.state);
> > +}
>
> Rather than force each test to invoke these via something like setup_test_common(),
> add the same kvm_arch_vm_post_create() hook that Vishal is likely going to add,
> and then automatically do all of the launch+measure+finish stuff for non-barebones
> VMs.  That will let SEV/SEV-ES tests use __vm_create_with_vcpus() and
> __vm_create().
>
> And it'd be a little gross, but I think it'd be wortwhile to add another layer
> to the "one_vcpu" helpers to make things even more convenient, e.g.
>
> struct kvm_vm *____vm_create_with_one_vcpu(enum vm_guest_mode mode,
>                                            struct kvm_vcpu **vcpu,
>                                            uint64_t extra_mem_pages,
>                                            void *guest_code)
> {
>         struct kvm_vcpu *vcpus[1];
>         struct kvm_vm *vm;
>
>         vm = __vm_create_with_vcpus(mode, 1, extra_mem_pages, guest_code, vcpus);
>
>         *vcpu = vcpus[0];
>         return vm;
> }
>
> static inline struct kvm_vm *__vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
>                                                        uint64_t extra_mem_pages,
>                                                        void *guest_code)
> {
>         return ____vm_create_with_one_vcpu(VM_MODE_DEFAULT, vcpu,
>                                            extra_mem_pages, guest_code);
> }
>
> static inline struct kvm_vm *____vm_create_with_one_vcpu(enum vm_guest_mode mode,
>                                            struct kvm_vcpu **vcpu,
>                                            uint64_t extra_mem_pages,
>                                            void *guest_code)
> ____vm_create_with_one_vcpu
>
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index dafe4471a6c7..593dfadb662e 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -298,9 +298,8 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
>
>         kvm_vm_elf_load(vm, program_invocation_name);
>
> -#ifdef __x86_64__
> -       vm_create_irqchip(vm);
> -#endif
> +       kvm_arch_vm_post_create(vm);
> +
>         return vm;
>  }
>
>
> [*] https://lore.kernel.org/all/YzsC4ibDqGh5qaP9@google.com

This refactor sounds good, working on this with a few changes.

Instead of kvm_init_vm_address_properties() as you suggested I've added this:

@@ -272,6 +275,8 @@ struct kvm_vm *____vm_create(enum vm_guest_mode
 mode, uint64_t nr_pages)
                vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
 #endif

+       kvm_init_vm_arch(vm);
+
        vm_open(vm);

        /* Limit to VA-bit canonical virtual addresses. */

And I need to put kvm_arch_vm_post_create() after the vCPUs are
created because the ordering we need is: KVM_SEV_INIT -> Create vCPUS
-> KVM_SEV_LAUNCH_FINISH.
