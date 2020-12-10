Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84882D6556
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 19:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389746AbgLJSoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 13:44:14 -0500
Received: from foss.arm.com ([217.140.110.172]:58520 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389384AbgLJSoE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 13:44:04 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4799130E;
        Thu, 10 Dec 2020 10:43:12 -0800 (PST)
Received: from [192.168.2.22] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 410233F718;
        Thu, 10 Dec 2020 10:43:11 -0800 (PST)
Subject: Re: [PATCH kvmtool] arm64: Determine kernel offset even on
 non-seekable file descriptors
To:     Marc Zyngier <maz@kernel.org>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>
References: <20201020123032.167234-1-andre.przywara@arm.com>
 <3d9099f63baed918b043c72909ee1e60@kernel.org>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <2f3d2559-13f7-6cb5-ef1f-3ecc590a7a83@arm.com>
Date:   Thu, 10 Dec 2020 18:42:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <3d9099f63baed918b043c72909ee1e60@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/2020 13:20, Marc Zyngier wrote:

Hi Marc,

thanks for having a look!

> On 2020-10-20 13:30, Andre Przywara wrote:
>> Commit c9acdae1d2e7 ("arm64: Use default kernel offset when the image
>> file can't be seeked") "guessed" the arm64 kernel offset to be the old
>> default of 512K if the file descriptor for the kernel image could not
>> be seeked. This mostly works today because most modern kernels are
>> somewhat forgiving when loaded at the wrong offset, but emit a warning:
>>
>> [Firmware Bug]: Kernel image misaligned at boot, please fix your
>> bootloader!
>>
>> To fix this properly, let's drop the seek operation altogether, instead
>> give the kernel header parsing function a memory buffer, containing the
>> first 64 bytes of the kernel file. We read the rest of the file into the
>> right location after this function has decoded the proper kernel offset.
>>
>> This brings back proper loading even for kernels loaded via pipes.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  arm/aarch64/include/kvm/kvm-arch.h |  3 ++-
>>  arm/aarch64/kvm.c                  | 26 ++++++++------------------
>>  arm/kvm.c                          | 13 ++++++++++---
>>  3 files changed, 20 insertions(+), 22 deletions(-)
>>
>> diff --git a/arm/aarch64/include/kvm/kvm-arch.h
>> b/arm/aarch64/include/kvm/kvm-arch.h
>> index 55ef8ed1..7e6cffb6 100644
>> --- a/arm/aarch64/include/kvm/kvm-arch.h
>> +++ b/arm/aarch64/include/kvm/kvm-arch.h
>> @@ -2,7 +2,8 @@
>>  #define KVM__KVM_ARCH_H
>>
>>  struct kvm;
>> -unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd);
>> +unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, void
>> *header,
>> +                         unsigned int bufsize);
>>
>>  #define ARM_MAX_MEMORY(kvm)    ((kvm)->cfg.arch.aarch32_guest    ?    \
>>                  ARM_LOMAP_MAX_MEMORY        :    \
>> diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
>> index 49e1dd31..9a6460ac 100644
>> --- a/arm/aarch64/kvm.c
>> +++ b/arm/aarch64/kvm.c
>> @@ -10,39 +10,29 @@
>>   * instead of Little-Endian. BE kernels of this vintage may fail to
>>   * boot. See Documentation/arm64/booting.rst in your local kernel tree.
>>   */
>> -unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd)
>> +unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm,
>> +                         void *buffer, unsigned int bufsize)
>>  {
>> -    struct arm64_image_header header;
>> -    off_t cur_offset;
>> -    ssize_t size;
>> +    struct arm64_image_header *header = buffer;
>>      const char *warn_str;
>>
>>      /* the 32bit kernel offset is a well known value */
>>      if (kvm->cfg.arch.aarch32_guest)
>>          return 0x8000;
>>
>> -    cur_offset = lseek(fd, 0, SEEK_CUR);
>> -    if (cur_offset == (off_t)-1 ||
>> -        lseek(fd, 0, SEEK_SET) == (off_t)-1) {
>> -        warn_str = "Failed to seek in kernel image file";
>> +    if (bufsize < sizeof(*header)) {
>> +        warn_str = "Provided kernel header too small";
>>          goto fail;
>>      }
>>
>> -    size = xread(fd, &header, sizeof(header));
>> -    if (size < 0 || (size_t)size < sizeof(header))
>> -        die("Failed to read kernel image header");
>> -
>> -    lseek(fd, cur_offset, SEEK_SET);
>> -
>> -    if (memcmp(&header.magic, ARM64_IMAGE_MAGIC, sizeof(header.magic)))
>> +    if (memcmp(&header->magic, ARM64_IMAGE_MAGIC,
>> sizeof(header->magic)))
>>          pr_warning("Kernel image magic not matching");
>>
>> -    if (le64_to_cpu(header.image_size))
>> -        return le64_to_cpu(header.text_offset);
>> +    if (le64_to_cpu(header->image_size))
>> +        return le64_to_cpu(header->text_offset);
>>
>>      warn_str = "Image size is 0";
>>  fail:
>>      pr_warning("%s, assuming TEXT_OFFSET to be 0x80000", warn_str);
>>      return 0x80000;
>>  }
>> -
>> diff --git a/arm/kvm.c b/arm/kvm.c
>> index 5aea18fe..685fabb1 100644
>> --- a/arm/kvm.c
>> +++ b/arm/kvm.c
>> @@ -90,12 +90,14 @@ void kvm__arch_init(struct kvm *kvm, const char
>> *hugetlbfs_path, u64 ram_size)
>>
>>  #define FDT_ALIGN    SZ_2M
>>  #define INITRD_ALIGN    4
>> +#define MAX_KERNEL_HEADER_SIZE    64
> 
> Isn't that arm64 specific? AFAICR, 32bit doesn't need any of this.

Strictly speaking: yes, it's not *needed* for arm32, but it doesn't hurt
as well. All this code *here* does it to split up the kernel file read
into two parts: a first "header" step (reading MAX_KERNEL_HEADER_SIZE),
and a second step for the rest, after we have learned the kernel offset
address.
I consider it just an implementation detail that ARM's
kvm__arch_get_kern_offset() implementation ignores all parameters and
returns a constant value.

So I don't see how this is really arm64 specific, it just tries to cover
both use cases in one function. We already do this by considering ARM
specific needs like highmem and space for the decompressor (which we
would need to keep for 32-bit guest kernels in any case, if I am not
mistaken).

Alternatively we could implement the whole of
kvm__arch_load_kernel_image() separately, but I am not sure that is
really better (for instance the whole initrd loading is the same).
Or split the kernel and initrd part and implement only the kernel
loading separately.

Cheers,
Andre.

>>  bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int
>> fd_initrd,
>>                   const char *kernel_cmdline)
>>  {
>>      void *pos, *kernel_end, *limit;
>>      unsigned long guest_addr;
>>      ssize_t file_size;
>> +    char header[MAX_KERNEL_HEADER_SIZE];
>>
>>      /*
>>       * Linux requires the initrd and dtb to be mapped inside lowmem,
>> @@ -103,16 +105,21 @@ bool kvm__arch_load_kernel_image(struct kvm
>> *kvm, int fd_kernel, int fd_initrd,
>>       */
>>      limit = kvm->ram_start + min(kvm->ram_size, (u64)SZ_256M) - 1;
>>
>> -    pos = kvm->ram_start + kvm__arch_get_kern_offset(kvm, fd_kernel);
>> +    if (xread(fd_kernel, header, sizeof(header)) != sizeof(header))
>> +        die_perror("kernel header read");
> 
> Same thing: 32bit doesn't require any preliminary read.
> 
>> +    pos = kvm->ram_start + kvm__arch_get_kern_offset(kvm, header,
>> +                             sizeof(header));
>>      kvm->arch.kern_guest_start = host_to_guest_flat(kvm, pos);
>> -    file_size = read_file(fd_kernel, pos, limit - pos);
>> +    memcpy(pos, header, sizeof(header));
>> +    file_size = read_file(fd_kernel, pos + sizeof(header),
>> +                  limit - pos - sizeof(header));
>>      if (file_size < 0) {
>>          if (errno == ENOMEM)
>>              die("kernel image too big to contain in guest memory.");
>>
>>          die_perror("kernel read");
>>      }
>> -    kernel_end = pos + file_size;
>> +    kernel_end = pos + file_size + sizeof(header);
>>      pr_debug("Loaded kernel to 0x%llx (%zd bytes)",
>>           kvm->arch.kern_guest_start, file_size);
> 
> I'd prefer the whole thing to be kept in the arm64-specific code, TBH.
> Or the 32bit support to be purged from kvmtool, which would simplify
> tons of things.
> 
> Thanks,
> 
>         M.

