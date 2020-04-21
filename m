Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC791B23E8
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 12:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgDUKda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 06:33:30 -0400
Received: from foss.arm.com ([217.140.110.172]:32862 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbgDUKdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 06:33:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E4521FB;
        Tue, 21 Apr 2020 03:33:22 -0700 (PDT)
Received: from [192.168.2.22] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D64013F73D;
        Tue, 21 Apr 2020 03:33:20 -0700 (PDT)
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool v3] Add emulation for CFI compatible flash memory
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Raphael Gault <raphael.gault@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
References: <20200221165532.90618-1-andre.przywara@arm.com>
 <2d3bad43-10a5-3ee1-72e7-e1da1d6c65dd@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <80912b9a-cd07-f46a-14c0-0010e3a5dfdd@arm.com>
Date:   Tue, 21 Apr 2020 11:32:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <2d3bad43-10a5-3ee1-72e7-e1da1d6c65dd@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/2020 16:15, Alexandru Elisei wrote:
> Hi,
> 
> I've tested this patch by running badblocks and fio on a flash device inside a
> guest, everything worked as expected.
> 
> I've also looked at the flowcharts for device operation from Intel Application
> Note 646, pages 12-21, and they seem implemented correctly.
> 
> A few minor issues below.

    ^^^

Slight understatement ;-)

> 
> On 2/21/20 4:55 PM, Andre Przywara wrote:
>> From: Raphael Gault <raphael.gault@arm.com>
>>
>> The EDK II UEFI firmware implementation requires some storage for the EFI
>> variables, which is typically some flash storage.
>> Since this is already supported on the EDK II side, we add a CFI flash
>> emulation to kvmtool.
>> This is backed by a file, specified via the --flash or -F command line
>> option. Any flash writes done by the guest will immediately be reflected
>> into this file (kvmtool mmap's the file).
>> The flash will be limited to the nearest power-of-2 size, so only the
>> first 2 MB of a 3 MB file will be used.
>>
>> This implements a CFI flash using the "Intel/Sharp extended command
>> set", as specified in:
>> - JEDEC JESD68.01
>> - JEDEC JEP137B
>> - Intel Application Note 646
>> Some gaps in those specs have been filled by looking at real devices and
>> other implementations (QEMU, Linux kernel driver).
>>
>> At the moment this relies on DT to advertise the base address of the
>> flash memory (mapped into the MMIO address space) and is only enabled
>> for ARM/ARM64. The emulation itself is architecture agnostic, though.
>>
>> This is one missing piece toward a working UEFI boot with kvmtool on
>> ARM guests, the other is to provide writable PCI BARs, which is WIP.
>>
>> Signed-off-by: Raphael Gault <raphael.gault@arm.com>
>> [Andre: rewriting and fixing]
>> Signed-off-by: Andre Przywra <andre.przywara@arm.com>
>> ---
>> Hi,
>>
>> an update fixing Alexandru's review comments (many thanks for those!)
>> The biggest change code-wise is the split of the MMIO handler into three
>> different functions. Another significant change is the rounding *down* of
>> the present flash file size to the nearest power-of-two, to match flash
>> hardware chips and Linux' expectations.
>>
>> Cheers,
>> Andre
>>
>> Changelog v2 .. v3:
>> - Breaking MMIO handling into three separate functions.
>> - Assing the flash base address in the memory map, but stay at 32 MB for now.
>>   The MMIO area has been moved up to 48 MB, to never overlap with the
>>   flash.
>> - Impose a limit of 16 MB for the flash size, mostly to fit into the
>>   (for now) fixed memory map.
>> - Trim flash size down to nearest power-of-2, to match hardware.
>> - Announce forced flash size trimming.
>> - Rework the CFI query table slightly, to add the addresses as array
>>   indicies.
>> - Fix error handling when creating the flash device.
>> - Fix pow2_size implementation for 0 and 1 as input values.
>> - Fix write buffer size handling.
>> - Improve some comments.
>>
>> Changelog v1 .. v2:
>> - Add locking for MMIO handling.
>> - Fold flash read into handler.
>> - Move pow2_size() into generic header.
>> - Spell out flash base address.
>>
>>  Makefile                          |   6 +
>>  arm/include/arm-common/kvm-arch.h |   8 +-
>>  builtin-run.c                     |   2 +
>>  hw/cfi_flash.c                    | 576 ++++++++++++++++++++++++++++++
>>  include/kvm/kvm-config.h          |   1 +
>>  include/kvm/util.h                |   8 +
>>  6 files changed, 599 insertions(+), 2 deletions(-)
>>  create mode 100644 hw/cfi_flash.c
>>
>> diff --git a/Makefile b/Makefile
>> index 3862112c..7ed6fb5e 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -170,6 +170,7 @@ ifeq ($(ARCH), arm)
>>  	CFLAGS		+= -march=armv7-a
>>  
>>  	ARCH_WANT_LIBFDT := y
>> +	ARCH_HAS_FLASH_MEM := y
>>  endif
>>  
>>  # ARM64
>> @@ -182,6 +183,7 @@ ifeq ($(ARCH), arm64)
>>  	ARCH_INCLUDE	+= -Iarm/aarch64/include
>>  
>>  	ARCH_WANT_LIBFDT := y
>> +	ARCH_HAS_FLASH_MEM := y
>>  endif
>>  
>>  ifeq ($(ARCH),mips)
>> @@ -261,6 +263,10 @@ ifeq (y,$(ARCH_HAS_FRAMEBUFFER))
>>  	endif
>>  endif
>>  
>> +ifeq (y,$(ARCH_HAS_FLASH_MEM))
>> +	OBJS	+= hw/cfi_flash.o
>> +endif
>> +
>>  ifeq ($(call try-build,$(SOURCE_ZLIB),$(CFLAGS),$(LDFLAGS) -lz),y)
>>  	CFLAGS_DYNOPT	+= -DCONFIG_HAS_ZLIB
>>  	LIBS_DYNOPT	+= -lz
>> diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
>> index b9d486d5..d84e50cd 100644
>> --- a/arm/include/arm-common/kvm-arch.h
>> +++ b/arm/include/arm-common/kvm-arch.h
>> @@ -8,7 +8,8 @@
>>  #include "arm-common/gic.h"
>>  
>>  #define ARM_IOPORT_AREA		_AC(0x0000000000000000, UL)
>> -#define ARM_MMIO_AREA		_AC(0x0000000000010000, UL)
>> +#define ARM_FLASH_AREA		_AC(0x0000000002000000, UL)
>> +#define ARM_MMIO_AREA		_AC(0x0000000003000000, UL)
>>  #define ARM_AXI_AREA		_AC(0x0000000040000000, UL)
>>  #define ARM_MEMORY_AREA		_AC(0x0000000080000000, UL)
>>  
>> @@ -21,7 +22,10 @@
>>  #define ARM_GIC_DIST_SIZE	0x10000
>>  #define ARM_GIC_CPUI_SIZE	0x20000
>>  
>> -#define ARM_IOPORT_SIZE		(ARM_MMIO_AREA - ARM_IOPORT_AREA)
>> +#define KVM_FLASH_MMIO_BASE	ARM_FLASH_AREA
>> +#define KVM_FLASH_MAX_SIZE	(ARM_MMIO_AREA - ARM_FLASH_AREA)
>> +
>> +#define ARM_IOPORT_SIZE		(1U << 16)
>>  #define ARM_VIRTIO_MMIO_SIZE	(ARM_AXI_AREA - (ARM_MMIO_AREA + ARM_GIC_SIZE))
>>  #define ARM_PCI_CFG_SIZE	(1ULL << 24)
>>  #define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
>> diff --git a/builtin-run.c b/builtin-run.c
>> index f8dc6c72..df8c6741 100644
>> --- a/builtin-run.c
>> +++ b/builtin-run.c
>> @@ -138,6 +138,8 @@ void kvm_run_set_wrapper_sandbox(void)
>>  			"Kernel command line arguments"),		\
>>  	OPT_STRING('f', "firmware", &(cfg)->firmware_filename, "firmware",\
>>  			"Firmware image to boot in virtual machine"),	\
>> +	OPT_STRING('F', "flash", &(cfg)->flash_filename, "flash",\
>> +			"Flash image to present to virtual machine"),	\
>>  									\
>>  	OPT_GROUP("Networking options:"),				\
>>  	OPT_CALLBACK_DEFAULT('n', "network", NULL, "network params",	\
>> diff --git a/hw/cfi_flash.c b/hw/cfi_flash.c
>> new file mode 100644
>> index 00000000..f66257c6
>> --- /dev/null
>> +++ b/hw/cfi_flash.c
>> @@ -0,0 +1,576 @@
>> +#include <stdbool.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <linux/bitops.h>
>> +#include <linux/err.h>
>> +#include <linux/sizes.h>
>> +#include <linux/types.h>
>> +
>> +#include "kvm/kvm.h"
>> +#include "kvm/kvm-arch.h"
>> +#include "kvm/devices.h"
>> +#include "kvm/fdt.h"
>> +#include "kvm/mutex.h"
>> +#include "kvm/util.h"
>> +
>> +/* The EDK2 driver hardcodes two 16-bit chips on a 32-bit bus. */
>> +#define CFI_NR_FLASH_CHIPS			2
>> +
>> +/* We always emulate a 32 bit bus width. */
>> +#define CFI_BUS_WIDTH				4
>> +
>> +/* The *effective* size of an erase block (over all chips) */
>> +#define FLASH_BLOCK_SIZE			SZ_64K
>> +
>> +#define PROGRAM_BUFF_SIZE_BITS			7
>> +#define PROGRAM_BUFF_SIZE			(1U << PROGRAM_BUFF_SIZE_BITS)
>> +
>> +/* CFI commands */
>> +#define CFI_CMD_LOCK_BLOCK			0x01
>> +#define CFI_CMD_ALTERNATE_WORD_PROGRAM_SETUP	0x10
>> +#define CFI_CMD_BLOCK_ERASE_SETUP		0x20
>> +#define CFI_CMD_WORD_PROGRAM_SETUP		0x40
>> +#define CFI_CMD_CLEAR_STATUS_REGISTER		0x50
>> +#define CFI_CMD_LOCK_BLOCK_SETUP		0x60
>> +#define CFI_CMD_READ_STATUS_REGISTER		0x70
>> +#define CFI_CMD_READ_JEDEC			0x90
>> +#define CFI_CMD_READ_CFI_QUERY			0x98
>> +#define CFI_CMD_BUFFERED_PROGRAM_CONFIRM	0xd0
>> +#define CFI_CMD_BLOCK_ERASE_CONFIRM		0xd0
>> +#define CFI_CMD_UNLOCK_BLOCK			0xd0
> 
> Can we express the three defines above that have the same value as having the
> value of the first define (like #define CFI_CMD_UNLOCK_BLOCK
> CFI_CMD_BUFFERED_PROGRAM_CONFIRM), so people won't think we've made a mistake? How
> about we use one define, CFI_CMD_CONFIRM?

Sure.

>> +#define CFI_CMD_BUFFERED_PROGRAM_SETUP		0xe8
>> +#define CFI_CMD_READ_ARRAY			0xff
>> +
>> +/*
>> + * CFI query table contents, as far as it is constant.
>> + */
>> +#define CFI_GEOM_OFFSET				0x27
>> +static u8 cfi_query_table[] = {
>> +		/* CFI query identification string */
>> +	[0x10] = 'Q', 'R', 'Y',		/* ID string */
>> +	0x01, 0x00,		/* primary command set: Intel/Sharp extended */
>> +	0x31, 0x00,		/* address of primary extended query table */
>> +	0x00, 0x00,		/* alternative command set: unused */
>> +	0x00, 0x00,		/* address of alternative extended query table*/
>> +		/* system interface information */
>> +	[0x1b] = 0x45,			/* minimum Vcc voltage: 4.5V */
>> +	0x55,			/* maximum Vcc voltage: 5.5V */
>> +	0x00,			/* minimum Vpp voltage: 0.0V (unused) */
>> +	0x00,			/* maximum Vpp voltage: 0.0V *(unused) */
>> +	0x01,			/* timeout for single word program: 2 us */
>> +	0x01,			/* timeout for multi-byte program: 2 us */
>> +	0x01,			/* timeout for block erase: 2 ms */
>> +	0x00,			/* timeout for full chip erase: not supported */
>> +	0x00,			/* max timeout for single word program: 1x */
>> +	0x00,			/* max timeout for mulit-byte program: 1x */
>> +	0x00,			/* max timeout for block erase: 1x */
>> +	0x00,			/* max timeout for chip erase: not supported */
>> +		/* flash geometry information */
>> +	[0x27] = 0x00,		/* size in power-of-2 bytes, filled later */
>> +	0x05, 0x00,		/* interface description: 32 and 16 bits */
>> +	PROGRAM_BUFF_SIZE_BITS + 1 - CFI_NR_FLASH_CHIPS, 0x00,
> 
> From JEDEC 6801: "Maximum number of bytes in multi-byte program = 2^n".What caught
> my eye was the fact that it's mixing bits and numbers. Shouldn't we subtract
> log2(CFI_NR_FLASH_CHIPS)? Did I misunderstand something?

I see that this deserves a comment:
(1 - x) is the same as -log2(x) for the two values of 1 and 2 ;-)

I could remove support for a single chip, but wanted to keep support for
it in, as this would have been the right thing to do. Supporting 2 chips
is just a concession to EDK-2, which only seems to support this
configuration (*cough* *cough* Juno).

I can make this more future proof by introducing a build bug for
anything other than 1 and 2, and wrapping this expression above in a
macro with a comment.

> 
>> +				/* number of bytes in write buffer */
>> +	0x01,			/* one erase block region */
>> +	0x00, 0x00, 0x00, 0x00, /* number and size of erase blocks, filled */
> 
> Nitpicking, but the world "filled" is misleading - we're not "filling in" the
> number in the struct, but rather we're dynamically generating it when the value is
> read by the guest. How about replacing "filled" with "generated"?

I think originally it broke 80 characters, but seems to fit now ;-)

> Also, the fact that we're generating at runtime the attributes that are unique to
> a flash file (basically, the size) lead me to believe that we support more than
> one flash device. However, that is not case, because we only save the last file
> name specified on the command line. Are there any plans to support multiple flash
> devices in the future?

I don't have any plans at the moment, but didn't want to introduce an
artifical limitation here. If someone needs more, it should be easy to
add - just figure out how to instantiate multiple devices.
Besides I think avoiding global state improves the quality of the code.

>> +		/* Intel primary algorithm extended query table */
>> +	[0x31] = 'P', 'R', 'I',
>> +	'1', '0',		/* version 1.0 */
>> +	0xa0, 0x00, 0x00, 0x00, /* optional features: instant lock & pm-read */
>> +	0x00,			/* no functions after suspend */
>> +	0x01, 0x00,		/* only lock bit supported */
>> +	0x50,			/* best Vcc value: 5.0V */
>> +	0x00,			/* best Vpp value: 0.0V (unused) */
>> +	0x01,			/* number of protection register fields */
>> +	0x00, 0x00, 0x00, 0x00,	/* protection field 1 description */
>> +};
> 
> I've been looking at Table 5 from Intel Application Note 646 and after byte D of
> the Intel primary algorithm extended query table I see that the fields are
> "Reserved for future versions of the SCS Specification".

This Intel AN is rather old, and also not that comprehensive "CFI flash
standard document" you might expect. So some "extensions" are rather
mandatory. I think the Linux driver expects those fields to be there.

>> +
> 
> Extra empty line?

Will replace it with "/* This line left intentionally blank */" ;-)

> 
>> +
>> +/*
>> + * Those states represent a subset of the CFI flash state machine.
>> + */
>> +enum cfi_flash_state {
>> +	READY,
>> +	LOCK_SETUP,
>> +	WP_SETUP,
>> +	BP_SETUP,
>> +	BP_LOAD,
>> +	ERASE_SETUP,
>> +};
>> +
>> +/*
>> + * The device can be in several **Read** modes.
>> + * We don't implement the asynchronous burst mode.
>> + */
>> +enum cfi_read_mode {
>> +	READ_ARRAY,
>> +	READ_STATUS,
>> +	READ_DEVICE_ID,
>> +	READ_QUERY,
>> +};
>> +
>> +struct cfi_flash_device {
>> +	struct device_header	dev_hdr;
>> +	/* Protects the CFI state machine variables in this data structure. */
>> +	struct mutex		mutex;
>> +	u64			base_addr;
>> +	u32			size;
>> +
>> +	void			*flash_memory;
>> +	u8			program_buffer[PROGRAM_BUFF_SIZE];
>> +	unsigned long		*lock_bm;
>> +	u64			last_address;
>> +	unsigned int		buff_written;
>> +	unsigned int		program_length;
>> +
>> +	enum cfi_flash_state	state;
>> +	enum cfi_read_mode	read_mode;
>> +	u16			rcr;
>> +	u8			sr;
> 
> I'm writing this here, because it applies to all the places where sr is set. I
> find myself constantly checking flowchart B6 from Intel Application Note 646, page
> 18. How about we use defines instead of magic numbers like 0x10, 0x12, 0x30 or 0x80?

Yes.

>> +};
>> +
>> +static int nr_erase_blocks(struct cfi_flash_device *sfdev)
>> +{
>> +	return sfdev->size / FLASH_BLOCK_SIZE;
>> +}
>> +
>> +/*
>> + * CFI queries always deal with one byte of information, possibly mirrored
>> + * to other bytes on the bus. This is dealt with in the callers.
>> + * The address provided is the one for 8-bit addressing, and would need to
>> + * be adjusted for wider accesses.
>> + */
>> +static u8 read_cfi(struct cfi_flash_device *sfdev, u64 addr)
>> +{
>> +	if (addr < 0x10)		/* CFI information starts at 0x10 */
>> +		return 0;
> 
> There's no need for that, elements 0-15 are already zero in cfi_query_table.

Well, I wanted to make it clear that a "read_cfi" really only deals with
CFI information, rather than relying on an implementation detail. But I
can remove this line.

>> +
>> +	if (addr > sizeof(cfi_query_table)) {
> 
> We have the macro ARRAY_SIZE in util.h for that.

I don't think the "number of elements in a C array" is the right
abstraction at this point, as we are interested in the actual byte size,
compared to the hardware address here. Yes, u8 is one byte, so it's the
same in this case, but I'd rather be explicit.

>> +		pr_debug("CFI query read access beyond the end of table");
>> +		return 0;
>> +	}
>> +
>> +	/* Fixup dynamic information in the geometry part of the table. */
>> +	switch (addr) {
>> +	case CFI_GEOM_OFFSET:		/* device size in bytes, power of two */
>> +		return pow2_size(sfdev->size / CFI_NR_FLASH_CHIPS);
>> +	case CFI_GEOM_OFFSET + 6:	/* number of erase blocks, minus one */
>> +		return (nr_erase_blocks(sfdev) - 1) & 0xff;
> 
> I'm not really sure why this is masking out all bytes but the first one. And why
> it does that only for this statement and another one below. Isn't this function
> returning an u8 already?

I'd still rather do this explicitly, to make this obvious that this
field is only one part of the value, and also to never return a value
that is bigger than the return type.
And you are right, I am missing this mask at the one below.

> 
>> +	case CFI_GEOM_OFFSET + 7:
>> +		return (nr_erase_blocks(sfdev) - 1) >> 8;
>> +	case CFI_GEOM_OFFSET + 8:	/* erase block size, in units of 256 */
>> +		return ((FLASH_BLOCK_SIZE / 256 ) / CFI_NR_FLASH_CHIPS) & 0xff;
> 
> Same question about the mask.
> 
>> +	case CFI_GEOM_OFFSET + 9:
>> +		return ((FLASH_BLOCK_SIZE / 256 ) / CFI_NR_FLASH_CHIPS) >> 8;
>> +	}
>> +
>> +	return cfi_query_table[addr];
>> +}
> 
> The CFI_GEOM_OFFSET doesn't really tell me anything. On the other hand,
> CFI_GEOM_DEVICE_SIZE (for example) is much more suggestive. All the magic numbers
> in this function could be replaced by defines,

But none of the documents seems to put names to those registers, they
all speak of offsets and length in bytes. So inventing names here would
make it harder to compare to the "specs". I see that the offsets from
the start of the region don't appear explicitly either, so I could
replace them with their absolute address value. "CFI_GEOM_OFFSET" would
then become 0x27, which would be the offset shown in table 4 of AN-646.
A reviewer could then match the hex offset against the comment and the
implementation.
Does that sound better?

> which would make the comments redundant
> and the code much easier to read.

Maybe easier to read, but not necessarily easier to verify. Since now
you would need to take an indirection and need to lookup what
CFI_GEOM_DEVICE_SIZE is.

> Adding 1 + 2 + 2 + 1 + 2 shouldn't be
> something that you have to do to when trying to understand the code.

Agreed.

> 
>> +
>> +static bool block_is_locked(struct cfi_flash_device *sfdev, u64 addr)
>> +{
>> +	int block_nr = addr / FLASH_BLOCK_SIZE;
>> +
>> +	return test_bit(block_nr, sfdev->lock_bm);
>> +}
>> +
>> +#define DEV_ID_MASK 0x7ff
>> +static u16 read_dev_id(struct cfi_flash_device *sfdev, u64 addr)
>> +{
>> +	switch ((addr & DEV_ID_MASK) / CFI_BUS_WIDTH) {
>> +	case 0x0:				/* vendor ID */
>> +		return 0x0000;
>> +	case 0x1:				/* device ID */
>> +		return 0xffff;
>> +	case 0x2:
>> +		return block_is_locked(sfdev, addr & ~DEV_ID_MASK);
>> +	case 0x5:
>> +		return sfdev->rcr;
>> +	default:			/* Ignore the other entries. */
>> +		return 0;
>> +	}
>> +}
> 
> I haven't been able to find in the documentation what the numbers above mean, I
> must have missed it. Would you mind pointing me in the right direction?

That's the legacy JEDEC ID mechanism, predating CFI. Back then you would
read vendor and device ID, and would then program the chip using a
specific algorithm for that chip (that you would need to know about).

I couldn't find a generic document either, but many chip datasheets
document this ("JEDEC ID 90h" seem to be good keywords).
And: many drivers rely on this, as this seems to be the only source of
information where you can get a vendor and *device* ID. Some drivers use
these for quirks, others just print those values.
The problem is that the EDK2 driver
(ArmPlatformPkg/Drivers/NorFlashDxe/NorFlashDxe.c) relies on the lock
bit function, so we have to implement this as well.
"rcr" stands for "Read Configuration Register", not sure we need this,
will check.

>> +
>> +static void lock_block(struct cfi_flash_device *sfdev, u64 addr, bool lock)
>> +{
>> +	int block_nr = addr / FLASH_BLOCK_SIZE;
>> +
>> +	if (lock)
>> +		set_bit(block_nr, sfdev->lock_bm);
>> +	else
>> +		clear_bit(block_nr, sfdev->lock_bm);
>> +}
>> +
>> +static void word_program(struct cfi_flash_device *sfdev,
>> +			 u64 addr, void *data, int len)
> 
> I think Intel Application Note 646 calls this writing a word, not programming a word.

Where do you find this? I only see "program (write)", but would rather
stick to "program", to denote an actual flash memory change operation,
in contrast to "write", which could be writing a command to the
registers or writing a byte to that write buffer.
I will check and adjust the usage in this file accordingly, if you agree.

> 
>> +{
>> +	if (block_is_locked(sfdev, addr)) {
>> +		sfdev->sr |= 0x12;
>> +		return;
>> +	}
>> +
>> +	memcpy(sfdev->flash_memory + addr, data, len);
>> +}
>> +
>> +/* Reset the program buffer state to prepare for follow-up writes. */
>> +static void buffer_setup(struct cfi_flash_device *sfdev)
>> +{
>> +	memset(sfdev->program_buffer, 0, sizeof(sfdev->program_buffer));
>> +	sfdev->last_address = ~0ULL;
>> +	sfdev->buff_written = 0;
>> +}
>> +
>> +static bool buffer_program(struct cfi_flash_device *sfdev,
>> +			   u64 addr, void *buffer, int len)
> 
> Isn't buffer_write a better name for a function that writes to a buffer? Intel
> Application Note 646 calls this process "write to buffer" in flowchart C1.

Yes, you are right. This does not program the flash array, so we should
use "write" here.

> 
>> +{
>> +	unsigned int buf_addr;
>> +
>> +	if (sfdev->buff_written >= sfdev->program_length)
> 
> Why is this called program_length when it is in fact the buffer length?

I think the rationale was that this is the size of the actual program
operation later on (this is set by software at the beginning of the
"write-to-buffer" sequence). I think I wanted to avoid confusion with
the size of the buffer we have allocated.
But I see that buffer_length would probably be less confusing.

>> +		return false;
>> +
>> +	/*
>> +	 * The first word written into the buffer after the setup command
>> +	 * happens to be the base address for the buffer.
>> +	 * All subsequent writes need to be within this address and this
>> +	 * address plus the buffer size, so keep this value around.
>> +	 */
>> +	if (sfdev->last_address == ~0ULL)
>> +		sfdev->last_address = addr;
> 
> Why is this called last_address when in fact is the buffer base address?

Seems like a leftover from some earlier version of the code.

> 
>> +
>> +	if (addr < sfdev->last_address)
>> +		return false;
>> +	buf_addr = addr - sfdev->last_address;
> 
> So far, in this function we have been using buff as a shorthand for buffer. Maybe
> buff_addr would be more consistent.

Sure.

>> +	if (buf_addr >= PROGRAM_BUFF_SIZE)
>> +		return false;
>> +
>> +	memcpy(sfdev->program_buffer + buf_addr, buffer, len);
> 
> What if buf_addr + len > sfdev->program_length?

I don't think that's our fault, and by checking that we don't exceed
*our* buffer we (kvmtool) are still safe.

> 
>> +	sfdev->buff_written += len;
>> +
>> +	return true;
>> +}
>> +
>> +static void buffer_confirm(struct cfi_flash_device *sfdev)
>> +{
>> +	if (block_is_locked(sfdev, sfdev->last_address)) {
>> +		sfdev->sr |= 0x12;
>> +		return;
>> +	}
>> +	memcpy(sfdev->flash_memory + sfdev->last_address,
>> +	       sfdev->program_buffer, sfdev->buff_written);
>> +}
>> +
>> +static void block_erase_confirm(struct cfi_flash_device *sfdev, u64 addr)
> 
> Before this function we've used addr for an offset in the flash file. After this
> function, we use faddr. It would be nice if we could settle on one name for it.

Yes.

>> +{
>> +	if (block_is_locked(sfdev, addr)) {
>> +		sfdev->sr |= 0x12;
>> +		return;
>> +	}
>> +
>> +	memset(sfdev->flash_memory + addr, 0xFF, FLASH_BLOCK_SIZE);
> 
> Why all 1's and not 0's, is this in the spec and I missed it? Why 0xFF and not
> 0xff, which looks more widely used?

Flash cells always erase to 1's, and can only be programmed to 0's.
Captial hex is just a leftover from a previous version.

> What if addr is not aligned to a block,
> wouldn't we keep the start of the block?

That would be user error, but I can surely align the block address,
which is probably what hardware would do.

> Why do we erase the block when the guest wants to confirm that the block was
> erased?

Not sure I understand? The "confirm" means software confirms the erase
command, so the erase operation is actually performed. The former erase
commands are just for "setup" and are not supposed to delete anything.

> Is it because it's more convenient not to keep track of the last deleted block?
> 
>> +}
>> +
>> +static void cfi_flash_read(struct cfi_flash_device *sfdev,
>> +			   u64 faddr, u8 *data, u32 len)
>> +{
>> +	u16 cfi_value = 0;
>> +
>> +	switch (sfdev->read_mode) {
>> +	case READ_ARRAY:
>> +		/* just copy the requested bytes from the array */
>> +		memcpy(data, sfdev->flash_memory + faddr, len);
> Shouldn't we check that faddr + len <= sfdev->size?

Maybe.

>> +		return;
>> +	case READ_STATUS:
>> +		cfi_value = sfdev->sr;
>> +		break;
>> +	case READ_DEVICE_ID:
>> +		cfi_value = read_dev_id(sfdev, faddr);
>> +		break;
>> +	case READ_QUERY:
>> +		cfi_value = read_cfi(sfdev, faddr / CFI_BUS_WIDTH);
>> +		break;
>> +	}
>> +	switch (len) {
>> +	case 1:
>> +		*data = cfi_value;
>> +		break;
>> +	case 8: memset(data + 4, 0, 4);
>> +		/* fall-through */
>> +	case 4:
>> +		if (CFI_NR_FLASH_CHIPS == 2)
>> +			memcpy(data + 2, &cfi_value, 2);
>> +		else
>> +			memset(data + 2, 0, 2);
>> +		/* fall-through */
>> +	case 2:
>> +		memcpy(data, &cfi_value, 2);
>> +		break;
>> +	default:
>> +		pr_debug("CFI flash: illegal access length %d for read mode %d",
>> +			 len, sfdev->read_mode);
>> +		break;
>> +	}
>> +}
>> +
>> +/*
>> + * Any writes happening in "READY" state don't actually write to the memory,
>> + * but are really treated as commands to advance the state machine and select
>> + * the next action.
>> + * Change the state and modes according to the value written. The address
>> + * that value is written to does not matter and is ignored.
>> + */
>> +static void cfi_flash_write_ready(struct cfi_flash_device *sfdev, u8 command)
>> +{
>> +	switch (command) {
>> +	case CFI_CMD_READ_JEDEC:
>> +		sfdev->read_mode = READ_DEVICE_ID;
> 
> So, the command CFI_CMD_READ_JEDEC puts the device in the READ_DEVICE_ID state.
> Why not READ_JEDEC? Better yet, why not CFI_CMD_READ_JEDEC_ID -> READ_JEDEC_ID, to
> match the name in the flow chart at page 14 from Intel Application Note 646?
> 
> Having the command match the state would make the transitions between the states a
> lot easier to follow, and there are a *lot* of transitions. Same for
> CFI_CMD_READ_STATUS_REGISTER -> READ_STATUS and CFI_CMD_READ_CFI_QUERY ->
> READ_QUERY below (arguably, these are slightly better). This is already the case
> for CFI_CMD_READ_ARRAY -> READ_ARRAY.
> 
>> +		break;
>> +	case CFI_CMD_READ_STATUS_REGISTER:
>> +		sfdev->read_mode = READ_STATUS;
>> +		break;
>> +	case CFI_CMD_READ_CFI_QUERY:
>> +		sfdev->read_mode = READ_QUERY;
>> +		break;
>> +	case CFI_CMD_CLEAR_STATUS_REGISTER:
>> +		sfdev->sr = 0x80;
>> +		break;
>> +	case CFI_CMD_WORD_PROGRAM_SETUP:
>> +	case CFI_CMD_ALTERNATE_WORD_PROGRAM_SETUP:
>> +		sfdev->state = WP_SETUP;
>> +		sfdev->read_mode = READ_STATUS;
>> +		break;
>> +	case CFI_CMD_LOCK_BLOCK_SETUP:
>> +		sfdev->state = LOCK_SETUP;
>> +		break;
>> +	case CFI_CMD_BLOCK_ERASE_SETUP:
>> +		sfdev->state = ERASE_SETUP;
>> +		sfdev->read_mode = READ_STATUS;
> 
> The "Block Erase Flowchart" from Intel Application Note 646, page 16 calls this
> command Single Block Erase Command and it receives the address for the block to be
> erased, which seems to be ignored here.

This is one place where I found the Intel AN not being precise: There
are two block addresses: the one provided with the setup command, and
the one provided with the confirm command. It is not clear which one to
use, the flow chart does not state this. Seems like most drivers provide
the same in both places. For convenience I just used the last one, since
this is easier accessible.

> 
>> +		break;
>> +	case CFI_CMD_BUFFERED_PROGRAM_SETUP:
>> +		buffer_setup(sfdev);
>> +		sfdev->state = BP_SETUP;
>> +		sfdev->read_mode = READ_STATUS;
>> +		break;
>> +	case CFI_CMD_BUFFERED_PROGRAM_CONFIRM:
>> +		pr_debug("CFI flash: unexpected confirm command 0xD0");
>> +		break;
>> +	default:
>> +		pr_debug("CFI flash: unknown command 0x%x", command);
> 
> Here, the unknown command is printed with small caps; above, for
> CFI_CMD_BUFFERED_PROGRAM_CONFIRM, it is printed with capital letters (0xD0).

Shocking! ;-)

> 
>> +		/* fall-through */
>> +	case CFI_CMD_READ_ARRAY:
>> +		sfdev->read_mode = READ_ARRAY;
>> +		break;
>> +	}
>> +}
>> +
>> +static void cfi_flash_write(struct cfi_flash_device *sfdev, u16 command,
>> +			    u64 faddr, u8 *data, u32 len)
>> +{
>> +	switch (sfdev->state) {
>> +	case READY:
>> +		cfi_flash_write_ready(sfdev, command & 0xff);
> 
> The implicit cast does the same thing as the mask. I have seen that in several
> places. Is it to emphasise the fact that the value will be truncated?

Yes, I'd rather be explicit here, to make it obvious that I discard the
upper 8 bits - so a reviewer wouldn't need to ask about this ;-)
Also I like this for the sake of robustness.

>> +		return;
>> +	case LOCK_SETUP:
>> +		switch (command & 0xff) {
>> +		case CFI_CMD_LOCK_BLOCK:
>> +			lock_block(sfdev, faddr, true);
>> +			sfdev->read_mode = READ_STATUS;
>> +			break;
>> +		case CFI_CMD_UNLOCK_BLOCK:
>> +			lock_block(sfdev, faddr, false);
>> +			sfdev->read_mode = READ_STATUS;
>> +			break;
>> +		default:
>> +			sfdev->sr |= 0x30;
>> +			break;
>> +		}
>> +		sfdev->state = READY;
>> +		break;
>> +
>> +	case WP_SETUP:
>> +		word_program(sfdev, faddr, data, len);
>> +		sfdev->read_mode = READ_STATUS;
>> +		sfdev->state = READY;
>> +		break;
>> +
>> +	case BP_LOAD:
> 
> What does the "BP" in BP_LOAD stand for? Wouldn't BUFFER_WRITE be a better name?
> And instead of BP_SETUP, BUFFER_WRITE_SETUP?

Sure.

> 
>> +		if (buffer_program(sfdev, faddr, data, len))
>> +			break;
>> +
>> +		if ((command & 0xFF) == CFI_CMD_BUFFERED_PROGRAM_CONFIRM) {
> 
> So far, the vast majority of hex numbers are with small caps (0xff, not 0xFF),
> including in this function. We use BP_SETUP for setting up a buffer write, BP_LOAD
> for doing the actual write and CFI_CMD_BUFFERED_PROGRAM_CONFIRM to confirm the
> write? Does that mean that "BP" means buffered program? Why not use buffer write
> everywhere, like it is called in the spec, and don't abbreviate it some of the time.

Some of the inconsistencies just stem from two different authors working
on that code. I tried to suppress the urge to rewrite everything just
because it didn't match my own style, and only change code that I need
to rewrite anyway.

I will use BUFFER_WRITE and BUFFER_SETUP for the states, this seems to
be both concise and still self-explanatory.

> 
>> +			buffer_confirm(sfdev);
>> +			sfdev->read_mode = READ_STATUS;
>> +		} else {
>> +			pr_debug("CFI flash: BP_LOAD: expected CONFIRM(0xd0), got 0x%x @ 0x%llx",
>> +				 command, faddr);
>> +			sfdev->sr |= 0x10;
>> +		}
>> +		sfdev->state = READY;
>> +		break;
>> +
>> +	case BP_SETUP:
>> +		sfdev->program_length = (command + 1) * CFI_BUS_WIDTH;
>> +		if (sfdev->program_length > PROGRAM_BUFF_SIZE)
>> +			sfdev->program_length = PROGRAM_BUFF_SIZE;
>> +		sfdev->state = BP_LOAD;
>> +		sfdev->read_mode = READ_STATUS;
>> +		break;
>> +
>> +	case ERASE_SETUP:
>> +		if ((command & 0xff) == CFI_CMD_BLOCK_ERASE_CONFIRM)
>> +			block_erase_confirm(sfdev, faddr);
>> +		else
>> +			sfdev->sr |= 0x30;
>> +
>> +		sfdev->state = READY;
>> +		sfdev->read_mode = READ_STATUS;
>> +		break;
>> +	}
> 
> I don't think it's outside the realm of possibility for someone to modify the
> state machine and forget to handle a state. How about an error message or an
> assert as the default case statement? Same for cfi_flash_read.

Yeah, can do.

> 
>> +}
>> +
>> +static void cfi_flash_mmio(struct kvm_cpu *vcpu,
>> +			   u64 addr, u8 *data, u32 len, u8 is_write,
>> +			   void *context)
>> +{
>> +	struct cfi_flash_device *sfdev = context;
>> +	u64 faddr = addr - sfdev->base_addr;
>> +	u32 value;
>> +
>> +	if (!is_write) {
>> +		mutex_lock(&sfdev->mutex);
>> +
>> +		cfi_flash_read(sfdev, faddr, data, len);
>> +
>> +		mutex_unlock(&sfdev->mutex);
>> +
>> +		return;
>> +	}
>> +
>> +	if (len > 4) {
>> +		pr_info("CFI flash: MMIO %d-bit write access not supported",
>> +			 len * 8);
>> +		return;
>> +	}
>> +
>> +	memcpy(&value, data, len);
>> +
>> +	mutex_lock(&sfdev->mutex);
>> +
>> +	cfi_flash_write(sfdev, value & 0xffff, faddr, data, len);
> 
> I'm not sure what to make of this. Would you mind explaining why using the mask
> when cfi_flash_write already converts the value to u16?

The idea behind this is to confirm that I (as the programmer) am aware
of this. Also this makes this more robust in case someone changes the
interface. I think the compiler does this anyway and won't do it twice,
so it should generate the same code.

>> +
>> +	mutex_unlock(&sfdev->mutex);
>> +}
>> +
>> +#ifdef CONFIG_HAS_LIBFDT
>> +static void generate_cfi_flash_fdt_node(void *fdt,
>> +					struct device_header *dev_hdr,
>> +					void (*generate_irq_prop)(void *fdt,
>> +								  u8 irq,
>> +								enum irq_type))
>> +{
>> +	struct cfi_flash_device *sfdev;
>> +	u64 reg_prop[2];
>> +
>> +	sfdev = container_of(dev_hdr, struct cfi_flash_device, dev_hdr);
>> +	reg_prop[0] = cpu_to_fdt64(sfdev->base_addr);
>> +	reg_prop[1] = cpu_to_fdt64(sfdev->size);
>> +
>> +	_FDT(fdt_begin_node(fdt, "flash"));
>> +	_FDT(fdt_property_cell(fdt, "bank-width", CFI_BUS_WIDTH));
>> +	_FDT(fdt_property_cell(fdt, "#address-cells", 0x1));
>> +	_FDT(fdt_property_cell(fdt, "#size-cells", 0x1));
>> +	_FDT(fdt_property_string(fdt, "compatible", "cfi-flash"));
>> +	_FDT(fdt_property_string(fdt, "label", "System-firmware"));
>> +	_FDT(fdt_property(fdt, "reg", &reg_prop, sizeof(reg_prop)));
>> +	_FDT(fdt_end_node(fdt));
>> +}
>> +#else
>> +#define generate_cfi_flash_fdt_node NULL
>> +#endif
>> +
>> +static struct cfi_flash_device *create_flash_device_file(struct kvm *kvm,
>> +							 const char *filename)
>> +{
>> +	struct cfi_flash_device *sfdev;
>> +	struct stat statbuf;
>> +	unsigned int value;
>> +	int ret;
>> +	int fd;
>> +
>> +	fd = open(filename, O_RDWR);
>> +	if (fd < 0)
>> +		return ERR_PTR(-errno);
>> +	if (fstat(fd, &statbuf) < 0) {
>> +		close(fd);
>> +		return ERR_PTR(-errno);
> 
> The function does cleanup in three separate places: here, when the malloc below
> fails, and at the end.
> 
>> +	}
>> +
>> +	sfdev = malloc(sizeof(struct cfi_flash_device));
>> +	if (!sfdev) {
>> +		close(fd);
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	sfdev->size = statbuf.st_size;
>> +	/* Round down to nearest power-of-2 size value. */
>> +	sfdev->size = 1U << (pow2_size(sfdev->size + 1) - 1);
>> +	if (sfdev->size > KVM_FLASH_MAX_SIZE)
>> +		sfdev->size = KVM_FLASH_MAX_SIZE;
>> +	if (sfdev->size < statbuf.st_size)
>> +		pr_info("Trimmed flash size down to %d bytes\n", sfdev->size);
> 
> First time I got this message, I checked the size of the flash file, to make sure
> kvmtool didn't truncate it. I guess I'm being paranoid, but how about rewording
> the message to something along the lines of: "Flash size not power of two; using
> the first xxxx bytes". Also, struct cfi_flash_device->size is an u32, and the
> format string uses %d.

Can reword it sure. And please don't put any valuable data in this flash
file ;-)

> 
>> +	sfdev->flash_memory = mmap(NULL, sfdev->size,
>> +				   PROT_READ | PROT_WRITE, MAP_SHARED,
>> +				   fd, 0);
>> +	if (sfdev->flash_memory == MAP_FAILED) {
>> +		ret = -errno;
>> +		goto out_err;
>> +	}
>> +	sfdev->base_addr = KVM_FLASH_MMIO_BASE;
>> +	sfdev->state = READY;
>> +	sfdev->read_mode = READ_ARRAY;
>> +	sfdev->sr = 0x80;
>> +	sfdev->rcr = 0xbfcf;
>> +
>> +	value = roundup(nr_erase_blocks(sfdev), BITS_PER_LONG) / 8;
>> +	sfdev->lock_bm = malloc(value);
>> +	memset(sfdev->lock_bm, 0, value);
>> +
>> +	sfdev->dev_hdr.bus_type = DEVICE_BUS_MMIO;
>> +	sfdev->dev_hdr.data = generate_cfi_flash_fdt_node;
>> +	mutex_init(&sfdev->mutex);
>> +	ret = device__register(&sfdev->dev_hdr);
>> +	if (ret)
>> +		goto out_unmap;
>> +
>> +	ret = kvm__register_mmio(kvm,
>> +				 sfdev->base_addr, sfdev->size,
>> +				 false, cfi_flash_mmio, sfdev);
>> +	if (ret) {
>> +		device__unregister(&sfdev->dev_hdr);
>> +		goto out_unmap;
>> +	}
>> +
>> +	return sfdev;
>> +
>> +out_unmap:
>> +	munmap(sfdev->flash_memory, sfdev->size);
>> +
>> +out_err:
>> +	close(fd);
>> +	free(sfdev);
>> +
>> +	return ERR_PTR(ret);
> 
> I was under the impression the pattern is to release resources in the reverse
> order they are allocated. In that case, close(fd) should be last.

Yes.

>> +}
>> +
>> +static int flash__init(struct kvm *kvm)
>> +{
>> +	struct cfi_flash_device *sfdev;
>> +
>> +	if (!kvm->cfg.flash_filename)
>> +		return 0;
>> +
>> +	sfdev = create_flash_device_file(kvm, kvm->cfg.flash_filename);
>> +	if (IS_ERR(sfdev))
>> +		return PTR_ERR(sfdev);
>> +
>> +	return 0;
>> +}
>> +dev_init(flash__init);
> 
> Nitpicking, but I think a better name would be cfi_flash__init: it's consistent
> with the file name and it would be easier to make the connection with this file if
> someone prints the init lists.
> 
> Overall, I feel there's a general inconsistency regarding function names: this one
> is prefixed with flash__, other are prefixed with cfi_flash_, others have no such
> prefix. For example, one function is named cfi_flash_read, another read_cfi, when
> a better name would be cfi_flash_read_query; in some places you put the action
> first (lock_block), in others the object first (word_program instead of
> program_word). Is there a pattern I am not seeing?

As mentioned: different authors. Originally most functions were using
flash as the prefix; I tended to use cfi_flash when I generalised some
of them because this version is now explicitly implementing generic CFI
flash.

> 
>> diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
>> index a052b0bc..f4a8b831 100644
>> --- a/include/kvm/kvm-config.h
>> +++ b/include/kvm/kvm-config.h
>> @@ -35,6 +35,7 @@ struct kvm_config {
>>  	const char *vmlinux_filename;
>>  	const char *initrd_filename;
>>  	const char *firmware_filename;
>> +	const char *flash_filename;
>>  	const char *console;
>>  	const char *dev;
>>  	const char *network;
>> diff --git a/include/kvm/util.h b/include/kvm/util.h
>> index 4ca7aa93..021369b4 100644
>> --- a/include/kvm/util.h
>> +++ b/include/kvm/util.h
>> @@ -104,6 +104,14 @@ static inline unsigned long roundup_pow_of_two(unsigned long x)
>>  	return x ? 1UL << fls_long(x - 1) : 0;
>>  }
>>  
>> +static inline int pow2_size(unsigned long x)
>> +{
>> +	if (x <= 1)
>> +		return x;
> 
> If I understand the function correctly, it should return 0 here because 2^0 < 2^1
> && 2^0 >= 1 && 2^0 >= 0.

The idea is to return the "number of bits needed to encode <x> different
values", or "number of bits needed to address <x> bytes of storage", in
our specific case. So 0 should return 0, and 1 returns 1.
Will add a comment.

Cheers,
Andre.

> 
> Thanks,
> Alex
>> +
>> +	return sizeof(x) * 8 - __builtin_clzl(x - 1);
>> +}
>> +
>>  struct kvm;
>>  void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
>>  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);

