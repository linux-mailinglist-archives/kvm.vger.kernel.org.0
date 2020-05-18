Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DBF1D792A
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 15:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgERNCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 09:02:21 -0400
Received: from foss.arm.com ([217.140.110.172]:40000 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbgERNCU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 09:02:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE02B101E;
        Mon, 18 May 2020 06:02:19 -0700 (PDT)
Received: from [192.168.2.22] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 135263F305;
        Mon, 18 May 2020 06:02:18 -0700 (PDT)
Subject: Re: [PATCH kvmtool] net: uip: Fix GCC 10 warning about checksum
 calculation
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org
References: <20200517152849.204717-1-andre.przywara@arm.com>
 <53980bb2-fb9b-886e-2a2a-c4301f50e4fe@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <ff1a0be5-dfa2-3702-a828-89de1d954f17@arm.com>
Date:   Mon, 18 May 2020 14:01:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <53980bb2-fb9b-886e-2a2a-c4301f50e4fe@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/2020 12:29, Alexandru Elisei wrote:
> Hi,
> 
> On 5/17/20 4:28 PM, Andre Przywara wrote:
>> GCC 10.1 generates a warning in net/ip/csum.c about exceeding a buffer
>> limit in a memcpy operation:
>> ------------------
>> In function ‘memcpy’,
>>     inlined from ‘uip_csum_udp’ at net/uip/csum.c:58:3:
>> /usr/include/aarch64-linux-gnu/bits/string_fortified.h:34:10: error: writing 1 byte into a region of size 0 [-Werror=stringop-overflow=]
>>    34 |   return __builtin___memcpy_chk (__dest, __src, __len, __bos0 (__dest));
>>       |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> In file included from net/uip/csum.c:1:
>> net/uip/csum.c: In function ‘uip_csum_udp’:
>> include/kvm/uip.h:132:6: note: at offset 0 to object ‘sport’ with size 2 declared here
>>   132 |  u16 sport;
>> ------------------
> 
> When I apply this patch, I get unrecognized characters:
> 
> In function <E2><80><98>memcpy<E2><80><99>,
>         inlined from <E2><80><98>uip_csum_udp<E2><80><99> at net/uip/csum.c:58:3:
>     /usr/include/aarch64-linux-gnu/bits/string_fortified.h:34:10: error: writing 1
> byte into a region of size 0 [-Werror=stringop-overflow=]
>        34 |   return __builtin___memcpy_chk (__dest, __src, __len, __bos0 (__dest));
>           |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     In file included from net/uip/csum.c:1:
>     net/uip/csum.c: In function <E2><80><98>uip_csum_udp<E2><80><99>:
>     include/kvm/uip.h:132:6: note: at offset 0 to object
> <E2><80><98>sport<E2><80><99> with size 2 declared here
>       132 |  u16 sport;
> 
> I looked at the patch source, and they're there also

Mmh, I see that GCC uses UTF-8 to render fancy ticks - for whatever
reason ;-) Removed them to avoid issues.

But where did you see those broken characters? Not sure if a non-UTF-8
capable terminal is still considered a thing in 2020?
I mean, even my Slackware is not ISO-8859-15 anymore ;-)

Fixed the rest and sent a v2.

Cheers,
Andre

>>
>> This warning originates from the code taking the address of the "sport"
>> member, then using that with some pointer arithmetic in a memcpy call.
>> GCC now sees that the object is only a u16, so copying 12 bytes into it
>> cannot be any good.
>> It's somewhat debatable whether this is a legitimate warning, as there
>> is enough storage at that place, and we knowingly use the struct and
>> its variabled-sized member at the end.
>>
>> However we can also rewrite the code, to not abuse the "&" operation of
>> some *member*, but take the address of the struct itself.
>> This makes the code less dodgy, and indeed appeases GCC 10.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> I've tested the patch and the compile errors have gone away for x86 and arm64.
> Tested virtio-net on both architectures and it works just like before:
> 
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
>> ---
>>  net/uip/csum.c | 26 ++++++++++++--------------
>>  1 file changed, 12 insertions(+), 14 deletions(-)
>>
>> diff --git a/net/uip/csum.c b/net/uip/csum.c
>> index 7ca8bada..607c9f1c 100644
>> --- a/net/uip/csum.c
>> +++ b/net/uip/csum.c
>> @@ -37,7 +37,7 @@ u16 uip_csum_udp(struct uip_udp *udp)
>>  	struct uip_pseudo_hdr hdr;
>>  	struct uip_ip *ip;
>>  	int udp_len;
>> -	u8 *pad;
>> +	u8 *udp_hdr = (u8*)udp + offsetof(struct uip_udp, sport);
> 
> Super minor nitpick: there should be a space between u8 and *.
> 
>>  
>>  	ip	  = &udp->ip;
>>  
>> @@ -50,13 +50,12 @@ u16 uip_csum_udp(struct uip_udp *udp)
>>  	udp_len	  = uip_udp_len(udp);
>>  
>>  	if (udp_len % 2) {
>> -		pad = (u8 *)&udp->sport + udp_len;
>> -		*pad = 0;
>> -		memcpy((u8 *)&udp->sport + udp_len + 1, &hdr, sizeof(hdr));
>> -		return uip_csum(0, (u8 *)&udp->sport, udp_len + 1 + sizeof(hdr));
>> +		udp_hdr[udp_len] = 0;		/* zero padding */
>> +		memcpy(udp_hdr + udp_len + 1, &hdr, sizeof(hdr));
>> +		return uip_csum(0, udp_hdr, udp_len + 1 + sizeof(hdr));
>>  	} else {
>> -		memcpy((u8 *)&udp->sport + udp_len, &hdr, sizeof(hdr));
>> -		return uip_csum(0, (u8 *)&udp->sport, udp_len + sizeof(hdr));
>> +		memcpy(udp_hdr + udp_len, &hdr, sizeof(hdr));
>> +		return uip_csum(0, udp_hdr, udp_len + sizeof(hdr));
>>  	}
>>  
>>  }
>> @@ -66,7 +65,7 @@ u16 uip_csum_tcp(struct uip_tcp *tcp)
>>  	struct uip_pseudo_hdr hdr;
>>  	struct uip_ip *ip;
>>  	u16 tcp_len;
>> -	u8 *pad;
>> +	u8 *tcp_hdr = (u8*)tcp + offsetof(struct uip_tcp, sport);
>>  
>>  	ip	  = &tcp->ip;
>>  	tcp_len   = ntohs(ip->len) - uip_ip_hdrlen(ip);
>> @@ -81,12 +80,11 @@ u16 uip_csum_tcp(struct uip_tcp *tcp)
>>  		pr_warning("tcp_len(%d) is too large", tcp_len);
>>  
>>  	if (tcp_len % 2) {
>> -		pad = (u8 *)&tcp->sport + tcp_len;
>> -		*pad = 0;
>> -		memcpy((u8 *)&tcp->sport + tcp_len + 1, &hdr, sizeof(hdr));
>> -		return uip_csum(0, (u8 *)&tcp->sport, tcp_len + 1 + sizeof(hdr));
>> +		tcp_hdr[tcp_len] = 0;		/* zero padding */
>> +		memcpy(tcp_hdr + tcp_len + 1, &hdr, sizeof(hdr));
>> +		return uip_csum(0, tcp_hdr, tcp_len + 1 + sizeof(hdr));
>>  	} else {
>> -		memcpy((u8 *)&tcp->sport + tcp_len, &hdr, sizeof(hdr));
>> -		return uip_csum(0, (u8 *)&tcp->sport, tcp_len + sizeof(hdr));
>> +		memcpy(tcp_hdr + tcp_len, &hdr, sizeof(hdr));
>> +		return uip_csum(0, tcp_hdr, tcp_len + sizeof(hdr));
>>  	}
>>  }
> 
> The patch looks functionally identical to the original version, and slightly
> easier to understand:
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 

