Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6135519BDA0
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 10:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbgDBIeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 04:34:16 -0400
Received: from foss.arm.com ([217.140.110.172]:39740 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727012AbgDBIeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 04:34:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A44C631B;
        Thu,  2 Apr 2020 01:34:15 -0700 (PDT)
Received: from [192.168.3.111] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC4A53F68F;
        Thu,  2 Apr 2020 01:34:14 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 20/32] pci: Add helpers for BAR values and
 memory/IO space access
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-21-alexandru.elisei@arm.com>
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
Message-ID: <7664f7c4-0535-6b6d-7ba9-edb407ecdee5@arm.com>
Date:   Thu, 2 Apr 2020 09:33:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326152438.6218-21-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/03/2020 15:24, Alexandru Elisei wrote:
> We're going to be checking the BAR type, the address written to it and if
> access to memory or I/O space is enabled quite often when we add support
> for reasignable BARs; make our life easier by adding helpers for it.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  include/kvm/pci.h   | 53 +++++++++++++++++++++++++++++++++++++++++++++
>  pci.c               |  4 ++--
>  powerpc/spapr_pci.c |  2 +-
>  3 files changed, 56 insertions(+), 3 deletions(-)
> 
> diff --git a/include/kvm/pci.h b/include/kvm/pci.h
> index ccb155e3e8fe..adb4b5c082d5 100644
> --- a/include/kvm/pci.h
> +++ b/include/kvm/pci.h
> @@ -5,6 +5,7 @@
>  #include <linux/kvm.h>
>  #include <linux/pci_regs.h>
>  #include <endian.h>
> +#include <stdbool.h>
>  
>  #include "kvm/devices.h"
>  #include "kvm/msi.h"
> @@ -161,4 +162,56 @@ void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data,
>  
>  void *pci_find_cap(struct pci_device_header *hdr, u8 cap_type);
>  
> +static inline bool __pci__memory_space_enabled(u16 command)
> +{
> +	return command & PCI_COMMAND_MEMORY;
> +}
> +
> +static inline bool pci__memory_space_enabled(struct pci_device_header *pci_hdr)
> +{
> +	return __pci__memory_space_enabled(pci_hdr->command);
> +}
> +
> +static inline bool __pci__io_space_enabled(u16 command)
> +{
> +	return command & PCI_COMMAND_IO;
> +}
> +
> +static inline bool pci__io_space_enabled(struct pci_device_header *pci_hdr)
> +{
> +	return __pci__io_space_enabled(pci_hdr->command);
> +}
> +
> +static inline bool __pci__bar_is_io(u32 bar)
> +{
> +	return bar & PCI_BASE_ADDRESS_SPACE_IO;
> +}
> +
> +static inline bool pci__bar_is_io(struct pci_device_header *pci_hdr, int bar_num)
> +{
> +	return __pci__bar_is_io(pci_hdr->bar[bar_num]);
> +}
> +
> +static inline bool pci__bar_is_memory(struct pci_device_header *pci_hdr, int bar_num)
> +{
> +	return !pci__bar_is_io(pci_hdr, bar_num);
> +}
> +
> +static inline u32 __pci__bar_address(u32 bar)
> +{
> +	if (__pci__bar_is_io(bar))
> +		return bar & PCI_BASE_ADDRESS_IO_MASK;
> +	return bar & PCI_BASE_ADDRESS_MEM_MASK;
> +}
> +
> +static inline u32 pci__bar_address(struct pci_device_header *pci_hdr, int bar_num)
> +{
> +	return __pci__bar_address(pci_hdr->bar[bar_num]);
> +}
> +
> +static inline u32 pci__bar_size(struct pci_device_header *pci_hdr, int bar_num)
> +{
> +	return pci_hdr->bar_size[bar_num];
> +}
> +
>  #endif /* KVM__PCI_H */
> diff --git a/pci.c b/pci.c
> index b6892d974c08..7399c76c0819 100644
> --- a/pci.c
> +++ b/pci.c
> @@ -185,7 +185,7 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>  	 * size, it will write the address back.
>  	 */
>  	if (bar < 6) {
> -		if (pci_hdr->bar[bar] & PCI_BASE_ADDRESS_SPACE_IO)
> +		if (pci__bar_is_io(pci_hdr, bar))
>  			mask = (u32)PCI_BASE_ADDRESS_IO_MASK;
>  		else
>  			mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
> @@ -211,7 +211,7 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>  		 */
>  		memcpy(&value, data, size);
>  		if (value == 0xffffffff)
> -			value = ~(pci_hdr->bar_size[bar] - 1);
> +			value = ~(pci__bar_size(pci_hdr, bar) - 1);
>  		/* Preserve the special bits. */
>  		value = (value & mask) | (pci_hdr->bar[bar] & ~mask);
>  		memcpy(base + offset, &value, size);
> diff --git a/powerpc/spapr_pci.c b/powerpc/spapr_pci.c
> index a15f7d895a46..7be44d950acb 100644
> --- a/powerpc/spapr_pci.c
> +++ b/powerpc/spapr_pci.c
> @@ -369,7 +369,7 @@ int spapr_populate_pci_devices(struct kvm *kvm,
>  				of_pci_b_ddddd(devid) |
>  				of_pci_b_fff(fn) |
>  				of_pci_b_rrrrrrrr(bars[i]));
> -			reg[n+1].size = cpu_to_be64(hdr->bar_size[i]);
> +			reg[n+1].size = cpu_to_be64(pci__bar_size(hdr, i));
>  			reg[n+1].addr = 0;
>  
>  			assigned_addresses[n].phys_hi = cpu_to_be32(
> 

