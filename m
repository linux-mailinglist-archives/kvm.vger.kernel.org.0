Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E0019F78C
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 16:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgDFOGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 10:06:22 -0400
Received: from foss.arm.com ([217.140.110.172]:46210 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728086AbgDFOGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 10:06:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8EE4B11D4;
        Mon,  6 Apr 2020 07:06:21 -0700 (PDT)
Received: from [192.168.3.111] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77FC73F73D;
        Mon,  6 Apr 2020 07:06:20 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 29/32] pci: Implement reassignable BARs
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-30-alexandru.elisei@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 xsFNBFNPCKMBEAC+6GVcuP9ri8r+gg2fHZDedOmFRZPtcrMMF2Cx6KrTUT0YEISsqPoJTKld
 tPfEG0KnRL9CWvftyHseWTnU2Gi7hKNwhRkC0oBL5Er2hhNpoi8x4VcsxQ6bHG5/dA7ctvL6
 kYvKAZw4X2Y3GTbAZIOLf+leNPiF9175S8pvqMPi0qu67RWZD5H/uT/TfLpvmmOlRzNiXMBm
 kGvewkBpL3R2clHquv7pB6KLoY3uvjFhZfEedqSqTwBVu/JVZZO7tvYCJPfyY5JG9+BjPmr+
 REe2gS6w/4DJ4D8oMWKoY3r6ZpHx3YS2hWZFUYiCYovPxfj5+bOr78sg3JleEd0OB0yYtzTT
 esiNlQpCo0oOevwHR+jUiaZevM4xCyt23L2G+euzdRsUZcK/M6qYf41Dy6Afqa+PxgMEiDto
 ITEH3Dv+zfzwdeqCuNU0VOGrQZs/vrKOUmU/QDlYL7G8OIg5Ekheq4N+Ay+3EYCROXkstQnf
 YYxRn5F1oeVeqoh1LgGH7YN9H9LeIajwBD8OgiZDVsmb67DdF6EQtklH0ycBcVodG1zTCfqM
 AavYMfhldNMBg4vaLh0cJ/3ZXZNIyDlV372GmxSJJiidxDm7E1PkgdfCnHk+pD8YeITmSNyb
 7qeU08Hqqh4ui8SSeUp7+yie9zBhJB5vVBJoO5D0MikZAODIDwARAQABzS1BbmRyZSBQcnp5
 d2FyYSAoQVJNKSA8YW5kcmUucHJ6eXdhcmFAYXJtLmNvbT7CwXsEEwECACUCGwMGCwkIBwMC
 BhUIAgkKCwQWAgMBAh4BAheABQJTWSV8AhkBAAoJEAL1yD+ydue63REP/1tPqTo/f6StS00g
 NTUpjgVqxgsPWYWwSLkgkaUZn2z9Edv86BLpqTY8OBQZ19EUwfNehcnvR+Olw+7wxNnatyxo
 D2FG0paTia1SjxaJ8Nx3e85jy6l7N2AQrTCFCtFN9lp8Pc0LVBpSbjmP+Peh5Mi7gtCBNkpz
 KShEaJE25a/+rnIrIXzJHrsbC2GwcssAF3bd03iU41J1gMTalB6HCtQUwgqSsbG8MsR/IwHW
 XruOnVp0GQRJwlw07e9T3PKTLj3LWsAPe0LHm5W1Q+euoCLsZfYwr7phQ19HAxSCu8hzp43u
 zSw0+sEQsO+9wz2nGDgQCGepCcJR1lygVn2zwRTQKbq7Hjs+IWZ0gN2nDajScuR1RsxTE4WR
 lj0+Ne6VrAmPiW6QqRhliDO+e82riI75ywSWrJb9TQw0+UkIQ2DlNr0u0TwCUTcQNN6aKnru
 ouVt3qoRlcD5MuRhLH+ttAcmNITMg7GQ6RQajWrSKuKFrt6iuDbjgO2cnaTrLbNBBKPTG4oF
 D6kX8Zea0KvVBagBsaC1CDTDQQMxYBPDBSlqYCb/b2x7KHTvTAHUBSsBRL6MKz8wwruDodTM
 4E4ToV9URl4aE/msBZ4GLTtEmUHBh4/AYwk6ACYByYKyx5r3PDG0iHnJ8bV0OeyQ9ujfgBBP
 B2t4oASNnIOeGEEcQ2rjzsFNBFNPCKMBEACm7Xqafb1Dp1nDl06aw/3O9ixWsGMv1Uhfd2B6
 it6wh1HDCn9HpekgouR2HLMvdd3Y//GG89irEasjzENZPsK82PS0bvkxxIHRFm0pikF4ljIb
 6tca2sxFr/H7CCtWYZjZzPgnOPtnagN0qVVyEM7L5f7KjGb1/o5EDkVR2SVSSjrlmNdTL2Rd
 zaPqrBoxuR/y/n856deWqS1ZssOpqwKhxT1IVlF6S47CjFJ3+fiHNjkljLfxzDyQXwXCNoZn
 BKcW9PvAMf6W1DGASoXtsMg4HHzZ5fW+vnjzvWiC4pXrcP7Ivfxx5pB+nGiOfOY+/VSUlW/9
 GdzPlOIc1bGyKc6tGREH5lErmeoJZ5k7E9cMJx+xzuDItvnZbf6RuH5fg3QsljQy8jLlr4S6
 8YwxlObySJ5K+suPRzZOG2+kq77RJVqAgZXp3Zdvdaov4a5J3H8pxzjj0yZ2JZlndM4X7Msr
 P5tfxy1WvV4Km6QeFAsjcF5gM+wWl+mf2qrlp3dRwniG1vkLsnQugQ4oNUrx0ahwOSm9p6kM
 CIiTITo+W7O9KEE9XCb4vV0ejmLlgdDV8ASVUekeTJkmRIBnz0fa4pa1vbtZoi6/LlIdAEEt
 PY6p3hgkLLtr2GRodOW/Y3vPRd9+rJHq/tLIfwc58ZhQKmRcgrhtlnuTGTmyUqGSiMNfpwAR
 AQABwsFfBBgBAgAJBQJTTwijAhsMAAoJEAL1yD+ydue64BgP/33QKczgAvSdj9XTC14wZCGE
 U8ygZwkkyNf021iNMj+o0dpLU48PIhHIMTXlM2aiiZlPWgKVlDRjlYuc9EZqGgbOOuR/pNYA
 JX9vaqszyE34JzXBL9DBKUuAui8z8GcxRcz49/xtzzP0kH3OQbBIqZWuMRxKEpRptRT0wzBL
 O31ygf4FRxs68jvPCuZjTGKELIo656/Hmk17cmjoBAJK7JHfqdGkDXk5tneeHCkB411p9WJU
 vMO2EqsHjobjuFm89hI0pSxlUoiTL0Nuk9Edemjw70W4anGNyaQtBq+qu1RdjUPBvoJec7y/
 EXJtoGxq9Y+tmm22xwApSiIOyMwUi9A1iLjQLmngLeUdsHyrEWTbEYHd2sAM2sqKoZRyBDSv
 ejRvZD6zwkY/9nRqXt02H1quVOP42xlkwOQU6gxm93o/bxd7S5tEA359Sli5gZRaucpNQkwd
 KLQdCvFdksD270r4jU/rwR2R/Ubi+txfy0dk2wGBjl1xpSf0Lbl/KMR5TQntELfLR4etizLq
 Xpd2byn96Ivi8C8u9zJruXTueHH8vt7gJ1oax3yKRGU5o2eipCRiKZ0s/T7fvkdq+8beg9ku
 fDO4SAgJMIl6H5awliCY2zQvLHysS/Wb8QuB09hmhLZ4AifdHyF1J5qeePEhgTA+BaUbiUZf
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <e812c62a-1151-46bf-3a5b-8de7e1f249d7@arm.com>
Date:   Mon, 6 Apr 2020 15:05:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326152438.6218-30-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/03/2020 15:24, Alexandru Elisei wrote:
> BARs are used by the guest to configure the access to the PCI device by
> writing the address to which the device will respond. The basic idea for
> adding support for reassignable BARs is straightforward: deactivate
> emulation for the memory region described by the old BAR value, and
> activate emulation for the new region.
> 
> BAR reassignement can be done while device access is enabled and memory
> regions for different devices can overlap as long as no access is made
> to the overlapping memory regions. This means that it is legal for the
> BARs of two distinct devices to point to an overlapping memory region,
> and indeed, this is how Linux does resource assignment at boot. To
> account for this situation, the simple algorithm described above is
> enhanced to scan for all devices and:
> 
> - Deactivate emulation for any BARs that might overlap with the new BAR
>   value.
> 
> - Enable emulation for any BARs that were overlapping with the old value
>   after the BAR has been updated.
> 
> Activating/deactivating emulation of a memory region has side effects.
> In order to prevent the execution of the same callback twice we now keep
> track of the state of the region emulation. For example, this can happen
> if we program a BAR with an address that overlaps a second BAR, thus
> deactivating emulation for the second BAR, and then we disable all
> region accesses to the second BAR by writing to the command register.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  include/kvm/pci.h |  14 ++-
>  pci.c             | 273 +++++++++++++++++++++++++++++++++++++---------
>  vfio/pci.c        |  12 ++
>  3 files changed, 244 insertions(+), 55 deletions(-)
> 
> diff --git a/include/kvm/pci.h b/include/kvm/pci.h
> index 1d7d4c0cea5a..be75f77fd2cb 100644
> --- a/include/kvm/pci.h
> +++ b/include/kvm/pci.h
> @@ -11,6 +11,17 @@
>  #include "kvm/msi.h"
>  #include "kvm/fdt.h"
>  
> +#define pci_dev_err(pci_hdr, fmt, ...) \
> +	pr_err("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
> +#define pci_dev_warn(pci_hdr, fmt, ...) \
> +	pr_warning("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
> +#define pci_dev_info(pci_hdr, fmt, ...) \
> +	pr_info("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
> +#define pci_dev_dbg(pci_hdr, fmt, ...) \
> +	pr_debug("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
> +#define pci_dev_die(pci_hdr, fmt, ...) \
> +	die("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
> +
>  /*
>   * PCI Configuration Mechanism #1 I/O ports. See Section 3.7.4.1.
>   * ("Configuration Mechanism #1") of the PCI Local Bus Specification 2.1 for
> @@ -142,7 +153,8 @@ struct pci_device_header {
>  	};
>  
>  	/* Private to lkvm */
> -	u32		bar_size[6];
> +	u32			bar_size[6];
> +	bool			bar_active[6];
>  	bar_activate_fn_t	bar_activate_fn;
>  	bar_deactivate_fn_t	bar_deactivate_fn;
>  	void *data;
> diff --git a/pci.c b/pci.c
> index c2860e6707fe..68ece65441a6 100644
> --- a/pci.c
> +++ b/pci.c
> @@ -71,6 +71,11 @@ static bool pci_bar_is_implemented(struct pci_device_header *pci_hdr, int bar_nu
>  	return pci__bar_size(pci_hdr, bar_num);
>  }
>  
> +static bool pci_bar_is_active(struct pci_device_header *pci_hdr, int bar_num)
> +{
> +	return  pci_hdr->bar_active[bar_num];
> +}
> +
>  static void *pci_config_address_ptr(u16 port)
>  {
>  	unsigned long offset;
> @@ -163,6 +168,46 @@ static struct ioport_operations pci_config_data_ops = {
>  	.io_out	= pci_config_data_out,
>  };
>  
> +static int pci_activate_bar(struct kvm *kvm, struct pci_device_header *pci_hdr,
> +			    int bar_num)
> +{
> +	int r = 0;
> +
> +	if (pci_bar_is_active(pci_hdr, bar_num))
> +		goto out;
> +
> +	r = pci_hdr->bar_activate_fn(kvm, pci_hdr, bar_num, pci_hdr->data);
> +	if (r < 0) {
> +		pci_dev_warn(pci_hdr, "Error activating emulation for BAR %d",
> +			    bar_num);
> +		goto out;
> +	}
> +	pci_hdr->bar_active[bar_num] = true;
> +
> +out:
> +	return r;
> +}
> +
> +static int pci_deactivate_bar(struct kvm *kvm, struct pci_device_header *pci_hdr,
> +			      int bar_num)
> +{
> +	int r = 0;
> +
> +	if (!pci_bar_is_active(pci_hdr, bar_num))
> +		goto out;
> +
> +	r = pci_hdr->bar_deactivate_fn(kvm, pci_hdr, bar_num, pci_hdr->data);
> +	if (r < 0) {
> +		pci_dev_warn(pci_hdr, "Error deactivating emulation for BAR %d",
> +			    bar_num);
> +		goto out;
> +	}
> +	pci_hdr->bar_active[bar_num] = false;
> +
> +out:
> +	return r;
> +}
> +
>  static void pci_config_command_wr(struct kvm *kvm,
>  				  struct pci_device_header *pci_hdr,
>  				  u16 new_command)
> @@ -179,26 +224,179 @@ static void pci_config_command_wr(struct kvm *kvm,
>  
>  		if (toggle_io && pci__bar_is_io(pci_hdr, i)) {
>  			if (__pci__io_space_enabled(new_command))
> -				pci_hdr->bar_activate_fn(kvm, pci_hdr, i,
> -							 pci_hdr->data);
> +				pci_activate_bar(kvm, pci_hdr, i);
>  			else
> -				pci_hdr->bar_deactivate_fn(kvm, pci_hdr, i,
> -							   pci_hdr->data);
> +				pci_deactivate_bar(kvm, pci_hdr, i);
>  		}
>  
>  		if (toggle_mem && pci__bar_is_memory(pci_hdr, i)) {
>  			if (__pci__memory_space_enabled(new_command))
> -				pci_hdr->bar_activate_fn(kvm, pci_hdr, i,
> -							 pci_hdr->data);
> +				pci_activate_bar(kvm, pci_hdr, i);
>  			else
> -				pci_hdr->bar_deactivate_fn(kvm, pci_hdr, i,
> -							   pci_hdr->data);
> +				pci_deactivate_bar(kvm, pci_hdr, i);
>  		}
>  	}
>  
>  	pci_hdr->command = new_command;
>  }
>  
> +static int pci_deactivate_bar_regions(struct kvm *kvm,
> +				      struct pci_device_header *pci_hdr,

What is this argument for? I don't see it used, also this function is
not used as a callback. A leftover from some refactoring?

> +				      u32 start, u32 size)
> +{
> +	struct device_header *dev_hdr;
> +	struct pci_device_header *tmp_hdr;
> +	u32 tmp_addr, tmp_size;
> +	int i, r;
> +
> +	dev_hdr = device__first_dev(DEVICE_BUS_PCI);
> +	while (dev_hdr) {
> +		tmp_hdr = dev_hdr->data;
> +		for (i = 0; i < 6; i++) {
> +			if (!pci_bar_is_implemented(tmp_hdr, i))
> +				continue;
> +
> +			tmp_addr = pci__bar_address(tmp_hdr, i);
> +			tmp_size = pci__bar_size(tmp_hdr, i);
> +
> +			if (tmp_addr + tmp_size <= start ||
> +			    tmp_addr >= start + size)
> +				continue;
> +
> +			r = pci_deactivate_bar(kvm, tmp_hdr, i);

This and the function below are identical, apart from this line here.
Any chance we can merge this?

> +			if (r < 0)
> +				return r;
> +		}
> +		dev_hdr = device__next_dev(dev_hdr);
> +	}
> +
> +	return 0;
> +}
> +
> +static int pci_activate_bar_regions(struct kvm *kvm,
> +				    struct pci_device_header *pci_hdr,

Same question about this parameter, we don't seem to need it. But you
should merge those two functions anyway.

The rest seems to look alright. The pci_config_bar_wr() looks a bit
lengthy, but I guess there is no way around it, since this is the gut of
the algorithm explained in the commit message. Can you maybe add a
condensed version of that explanation to the code?

Thanks,
Andre


> +				    u32 start, u32 size)
> +{
> +	struct device_header *dev_hdr;
> +	struct pci_device_header *tmp_hdr;
> +	u32 tmp_addr, tmp_size;
> +	int i, r;
> +
> +	dev_hdr = device__first_dev(DEVICE_BUS_PCI);
> +	while (dev_hdr) {
> +		tmp_hdr = dev_hdr->data;
> +		for (i = 0; i < 6; i++) {
> +			if (!pci_bar_is_implemented(tmp_hdr, i))
> +				continue;
> +
> +			tmp_addr = pci__bar_address(tmp_hdr, i);
> +			tmp_size = pci__bar_size(tmp_hdr, i);
> +
> +			if (tmp_addr + tmp_size <= start ||
> +			    tmp_addr >= start + size)
> +				continue;
> +
> +			r = pci_activate_bar(kvm, tmp_hdr, i);
> +			if (r < 0)
> +				return r;
> +		}
> +		dev_hdr = device__next_dev(dev_hdr);
> +	}
> +
> +	return 0;
> +}
> +
> +static void pci_config_bar_wr(struct kvm *kvm,
> +			      struct pci_device_header *pci_hdr, int bar_num,
> +			      u32 value)
> +{
> +	u32 old_addr, new_addr, bar_size;
> +	u32 mask;
> +	int r;
> +
> +	if (pci__bar_is_io(pci_hdr, bar_num))
> +		mask = (u32)PCI_BASE_ADDRESS_IO_MASK;
> +	else
> +		mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
> +
> +	/*
> +	 * If the kernel masks the BAR, it will expect to find the size of the
> +	 * BAR there next time it reads from it. After the kernel reads the
> +	 * size, it will write the address back.
> +	 *
> +	 * According to the PCI local bus specification REV 3.0: The number of
> +	 * upper bits that a device actually implements depends on how much of
> +	 * the address space the device will respond to. A device that wants a 1
> +	 * MB memory address space (using a 32-bit base address register) would
> +	 * build the top 12 bits of the address register, hardwiring the other
> +	 * bits to 0.
> +	 *
> +	 * Furthermore, software can determine how much address space the device
> +	 * requires by writing a value of all 1's to the register and then
> +	 * reading the value back. The device will return 0's in all don't-care
> +	 * address bits, effectively specifying the address space required.
> +	 *
> +	 * Software computes the size of the address space with the formula
> +	 * S =  ~B + 1, where S is the memory size and B is the value read from
> +	 * the BAR. This means that the BAR value that kvmtool should return is
> +	 * B = ~(S - 1).
> +	 */
> +	if (value == 0xffffffff) {
> +		value = ~(pci__bar_size(pci_hdr, bar_num) - 1);
> +		/* Preserve the special bits. */
> +		value = (value & mask) | (pci_hdr->bar[bar_num] & ~mask);
> +		pci_hdr->bar[bar_num] = value;
> +		return;
> +	}
> +
> +	value = (value & mask) | (pci_hdr->bar[bar_num] & ~mask);
> +
> +	/* Don't toggle emulation when region type access is disbled. */
> +	if (pci__bar_is_io(pci_hdr, bar_num) &&
> +	    !pci__io_space_enabled(pci_hdr)) {
> +		pci_hdr->bar[bar_num] = value;
> +		return;
> +	}
> +
> +	if (pci__bar_is_memory(pci_hdr, bar_num) &&
> +	    !pci__memory_space_enabled(pci_hdr)) {
> +		pci_hdr->bar[bar_num] = value;
> +		return;
> +	}
> +
> +	old_addr = pci__bar_address(pci_hdr, bar_num);
> +	new_addr = __pci__bar_address(value);
> +	bar_size = pci__bar_size(pci_hdr, bar_num);
> +
> +	r = pci_deactivate_bar(kvm, pci_hdr, bar_num);
> +	if (r < 0)
> +		return;
> +
> +	r = pci_deactivate_bar_regions(kvm, pci_hdr, new_addr, bar_size);
> +	if (r < 0) {
> +		/*
> +		 * We cannot update the BAR because of an overlapping region
> +		 * that failed to deactivate emulation, so keep the old BAR
> +		 * value and re-activate emulation for it.
> +		 */
> +		pci_activate_bar(kvm, pci_hdr, bar_num);
> +		return;
> +	}
> +
> +	pci_hdr->bar[bar_num] = value;
> +	r = pci_activate_bar(kvm, pci_hdr, bar_num);
> +	if (r < 0) {
> +		/*
> +		 * New region cannot be emulated, re-enable the regions that
> +		 * were overlapping.
> +		 */
> +		pci_activate_bar_regions(kvm, pci_hdr, new_addr, bar_size);
> +		return;
> +	}
> +
> +	pci_activate_bar_regions(kvm, pci_hdr, old_addr, bar_size);
> +}
> +
>  void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size)
>  {
>  	void *base;
> @@ -206,7 +404,6 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>  	struct pci_device_header *pci_hdr;
>  	u8 dev_num = addr.device_number;
>  	u32 value = 0;
> -	u32 mask;
>  
>  	if (!pci_device_exists(addr.bus_number, dev_num, 0))
>  		return;
> @@ -231,46 +428,13 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>  	}
>  
>  	bar = (offset - PCI_BAR_OFFSET(0)) / sizeof(u32);
> -
> -	/*
> -	 * If the kernel masks the BAR, it will expect to find the size of the
> -	 * BAR there next time it reads from it. After the kernel reads the
> -	 * size, it will write the address back.
> -	 */
>  	if (bar < 6) {
> -		if (pci__bar_is_io(pci_hdr, bar))
> -			mask = (u32)PCI_BASE_ADDRESS_IO_MASK;
> -		else
> -			mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
> -		/*
> -		 * According to the PCI local bus specification REV 3.0:
> -		 * The number of upper bits that a device actually implements
> -		 * depends on how much of the address space the device will
> -		 * respond to. A device that wants a 1 MB memory address space
> -		 * (using a 32-bit base address register) would build the top
> -		 * 12 bits of the address register, hardwiring the other bits
> -		 * to 0.
> -		 *
> -		 * Furthermore, software can determine how much address space
> -		 * the device requires by writing a value of all 1's to the
> -		 * register and then reading the value back. The device will
> -		 * return 0's in all don't-care address bits, effectively
> -		 * specifying the address space required.
> -		 *
> -		 * Software computes the size of the address space with the
> -		 * formula S = ~B + 1, where S is the memory size and B is the
> -		 * value read from the BAR. This means that the BAR value that
> -		 * kvmtool should return is B = ~(S - 1).
> -		 */
>  		memcpy(&value, data, size);
> -		if (value == 0xffffffff)
> -			value = ~(pci__bar_size(pci_hdr, bar) - 1);
> -		/* Preserve the special bits. */
> -		value = (value & mask) | (pci_hdr->bar[bar] & ~mask);
> -		memcpy(base + offset, &value, size);
> -	} else {
> -		memcpy(base + offset, data, size);
> +		pci_config_bar_wr(kvm, pci_hdr, bar, value);
> +		return;
>  	}
> +
> +	memcpy(base + offset, data, size);
>  }
>  
>  void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data, int size)
> @@ -338,20 +502,21 @@ int pci__register_bar_regions(struct kvm *kvm, struct pci_device_header *pci_hdr
>  			continue;
>  
>  		has_bar_regions = true;
> +		assert(!pci_bar_is_active(pci_hdr, i));
>  
>  		if (pci__bar_is_io(pci_hdr, i) &&
>  		    pci__io_space_enabled(pci_hdr)) {
> -				r = bar_activate_fn(kvm, pci_hdr, i, data);
> -				if (r < 0)
> -					return r;
> -			}
> +			r = pci_activate_bar(kvm, pci_hdr, i);
> +			if (r < 0)
> +				return r;
> +		}
>  
>  		if (pci__bar_is_memory(pci_hdr, i) &&
>  		    pci__memory_space_enabled(pci_hdr)) {
> -				r = bar_activate_fn(kvm, pci_hdr, i, data);
> -				if (r < 0)
> -					return r;
> -			}
> +			r = pci_activate_bar(kvm, pci_hdr, i);
> +			if (r < 0)
> +				return r;
> +		}
>  	}
>  
>  	assert(has_bar_regions);
> diff --git a/vfio/pci.c b/vfio/pci.c
> index 18e22a8c5320..2b891496547d 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -457,6 +457,7 @@ static int vfio_pci_bar_activate(struct kvm *kvm,
>  	struct vfio_pci_msix_pba *pba = &pdev->msix_pba;
>  	struct vfio_pci_msix_table *table = &pdev->msix_table;
>  	struct vfio_region *region;
> +	u32 bar_addr;
>  	bool has_msix;
>  	int ret;
>  
> @@ -465,7 +466,14 @@ static int vfio_pci_bar_activate(struct kvm *kvm,
>  	region = &vdev->regions[bar_num];
>  	has_msix = pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX;
>  
> +	bar_addr = pci__bar_address(pci_hdr, bar_num);
> +	if (pci__bar_is_io(pci_hdr, bar_num))
> +		region->port_base = bar_addr;
> +	else
> +		region->guest_phys_addr = bar_addr;
> +
>  	if (has_msix && (u32)bar_num == table->bar) {
> +		table->guest_phys_addr = region->guest_phys_addr;
>  		ret = kvm__register_mmio(kvm, table->guest_phys_addr,
>  					 table->size, false,
>  					 vfio_pci_msix_table_access, pdev);
> @@ -474,6 +482,10 @@ static int vfio_pci_bar_activate(struct kvm *kvm,
>  	}
>  
>  	if (has_msix && (u32)bar_num == pba->bar) {
> +		if (pba->bar == table->bar)
> +			pba->guest_phys_addr = table->guest_phys_addr + table->size;
> +		else
> +			pba->guest_phys_addr = region->guest_phys_addr;
>  		ret = kvm__register_mmio(kvm, pba->guest_phys_addr,
>  					 pba->size, false,
>  					 vfio_pci_msix_pba_access, pdev);
> 

