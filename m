Return-Path: <kvm+bounces-65185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 68BADC9DC8D
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 06:10:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 502CC3A688B
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 05:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F11284662;
	Wed,  3 Dec 2025 05:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="AHebzQJd"
X-Original-To: kvm@vger.kernel.org
Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B91279DAE
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 05:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764738636; cv=none; b=iwcaBU4OoU/A1m205dTiZi8LqrqGoK/2L5kfDU2stY2+EvJ6jEO4VswYrBuo6dQ+9Ny3a912xv+LAUFCS5RikkTZm+H0/iqN7F2M1oHqLWCIYnxvGc7yFEPClwSeJr6puhznuJ8BuNCAyHYwH5uBu4s419BvywR0wKGmxfAZywY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764738636; c=relaxed/simple;
	bh=EZco+88Y78IvWrfrJZkr11uVXgBLNbqBKW/cA9HQDdw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CIHQ96SRq1291t2lCIsh4IivbkwLQpDXYHGRpk6TxfqVO3hmqzfhXdP6GyvC+ZbI/94k3tBd7IwFhs4WhFvPi3kY2RglGhg6zLpXszxxpUsuTfeZIigKhg2Ba6Qtt8kvM1lIfIEKMIeN4brcZ9KLwk6EcvEDeWlIMFHhnNB5s/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=AHebzQJd; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Received: from eig-obgw-6002b.ext.cloudfilter.net ([10.0.30.203])
	by cmsmtp with ESMTPS
	id QWBOv0zuMKXDJQf8GvXtYd; Wed, 03 Dec 2025 05:10:28 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id Qf8Fvtbxkfjs1Qf8GvF6Hn; Wed, 03 Dec 2025 05:10:28 +0000
X-Authority-Analysis: v=2.4 cv=So+Q6OO0 c=1 sm=1 tr=0 ts=692fc644
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=ujWNxKVE5dX343uAl30YYw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=SYA4UEjrzyP_W4GMUF8A:9 a=QEXdDO2ut3YA:10 a=1ugCHEcPnPZfhCUW74ct:22
 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EiJ/gpk8T6f2b1RgxrOw36SaHQRodGlXDyE2RAmZZ+M=; b=AHebzQJd7gj3ibRnOveD9UBu6L
	eC22TZiO2ZS/2m4nkeX0yfBXkc1xb8XFF/qW51fq4k5g25RslWJvOzWYb46o+TZ1HcFHJAbWJx8Br
	QW8rYAQmU092HZ9CT0FMim45Tdr92ox1z5nnTJDyJlXQwGPskqDrQ6tET8IgbNK1omJ+3c//IxOZm
	HC8UM1iLEVgG0A/UFgFmjSk9RNtdYffv8YHMfyrtJ7NYMXknmb4EtZu0rpV/Oha61lCc86B+dBK2f
	YUYpVXv8aKt0wXorZTBSpR55Nl+OXXscgq6oLgYpN6XE9N+BmwXVHl9CUubaXewcA1IMu17UNjhw2
	MyMdu6hA==;
Received: from i118-18-233-1.s41.a027.ap.plala.or.jp ([118.18.233.1]:60879 helo=[10.83.24.44])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1vQf8F-00000001b6i-1OkI;
	Tue, 02 Dec 2025 23:10:27 -0600
Message-ID: <127bd529-45a0-47bd-8364-5e99144cb773@embeddedor.com>
Date: Wed, 3 Dec 2025 14:10:19 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] KVM: Avoid a few dozen
 -Wflex-array-member-not-at-end warnings
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <aPfNKRpLfhmhYqfP@kspp>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <aPfNKRpLfhmhYqfP@kspp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 118.18.233.1
X-Source-L: No
X-Exim-ID: 1vQf8F-00000001b6i-1OkI
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: i118-18-233-1.s41.a027.ap.plala.or.jp ([10.83.24.44]) [118.18.233.1]:60879
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBtTB2eYo7XMiB8hvQq7795lWw/+Ltp967Uf51wxgVXG8tbo6hSQ8fIOcgwOzeYLhhSRSizTX7Ry93IEoOGnTtPkzywvw0hMMB48xIVYbq8Y4EFntRrc
 ncD0pYC6Ao6/zWkaI2tCN/rFk4sPUFryt4qTnPG/+1ycnqNHqn83NqaVgrM9claOcr2r62eK9GFl7Cl/mwKBL2T9HMygIZe3WqU=

Hi all,

Friendly ping: who can take this, please? :)

Thanks!
-Gustavo

On 10/22/25 03:12, Gustavo A. R. Silva wrote:
> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
> 
> So, in order to avoid ending up with a flexible-array member in the
> middle of multiple other structs, we use the `__struct_group()` helper
> to separate the flexible array from the rest of the members in the
> flexible structure, and use the tagged `struct kvm_stats_desc_hdr`
> instead of `struct kvm_stats_desc`.
> 
> So, with these changes, fix 51 instances of the following type of
> warning:
> 
> 49 ./include/linux/kvm_host.h:1923:31: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 1 .../include/linux/kvm_host.h:1923:31: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 1 +./include/linux/kvm_host.h:1923:31: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> Notice that, before and after the changes, struct sizes and member offsets
> remain unchanged:
> 
> BEFORE
> 
> struct kvm_stats_desc {
>          __u32                      flags;                /*     0     4 */
>          __s16                      exponent;             /*     4     2 */
>          __u16                      size;                 /*     6     2 */
>          __u32                      offset;               /*     8     4 */
>          __u32                      bucket_size;          /*    12     4 */
>          char                       name[];               /*    16     0 */
> 
>          /* size: 16, cachelines: 1, members: 6 */
>          /* last cacheline: 16 bytes */
> };
> 
> struct _kvm_stats_desc {
>          struct kvm_stats_desc      desc;                 /*     0    16 */
>          char                       name[48];             /*    16    48 */
> 
>          /* size: 64, cachelines: 1, members: 2 */
> };
> 
> AFTER:
> 
> struct kvm_stats_desc {
>          union {
>                  struct {
>                          __u32      flags;                /*     0     4 */
>                          __s16      exponent;             /*     4     2 */
>                          __u16      size;                 /*     6     2 */
>                          __u32      offset;               /*     8     4 */
>                          __u32      bucket_size;          /*    12     4 */
>                  };                                       /*     0    16 */
>                  struct kvm_stats_desc_hdr __hdr;         /*     0    16 */
>          };                                               /*     0    16 */
>          char                       name[];               /*    16     0 */
> 
>          /* size: 16, cachelines: 1, members: 2 */
>          /* last cacheline: 16 bytes */
> };
> 
> struct _kvm_stats_desc {
>          struct kvm_stats_desc_hdr  desc;                 /*     0    16 */
>          char                       name[48];             /*    16    48 */
> 
>          /* size: 64, cachelines: 1, members: 2 */
> };
> 
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   include/uapi/linux/kvm.h | 21 ++++++++++++++++-----
>   include/linux/kvm_host.h |  2 +-
>   2 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 6efa98a57ec1..99d13ebc5e82 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -14,6 +14,12 @@
>   #include <linux/ioctl.h>
>   #include <asm/kvm.h>
>   
> +#ifdef __KERNEL__
> +#include <linux/stddef.h>       /* for offsetof */
> +#else
> +#include <stddef.h>             /* for offsetof */
> +#endif
> +
>   #define KVM_API_VERSION 12
>   
>   /*
> @@ -1563,13 +1569,18 @@ struct kvm_stats_header {
>    *        &kvm_stats_header->name_size.
>    */
>   struct kvm_stats_desc {
> -	__u32 flags;
> -	__s16 exponent;
> -	__u16 size;
> -	__u32 offset;
> -	__u32 bucket_size;
> +	/* New members MUST be added within the __struct_group() macro below. */
> +	__struct_group(kvm_stats_desc_hdr, __hdr, /* no attrs */,
> +		__u32 flags;
> +		__s16 exponent;
> +		__u16 size;
> +		__u32 offset;
> +		__u32 bucket_size;
> +	);
>   	char name[];
>   };
> +_Static_assert(offsetof(struct kvm_stats_desc, name) == sizeof(struct kvm_stats_desc_hdr),
> +	       "struct member likely outside of __struct_group()");
>   
>   #define KVM_GET_STATS_FD  _IO(KVMIO,  0xce)
>   
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index fa36e70df088..c630991f72be 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1920,7 +1920,7 @@ struct kvm_stat_data {
>   };
>   
>   struct _kvm_stats_desc {
> -	struct kvm_stats_desc desc;
> +	struct kvm_stats_desc_hdr desc;
>   	char name[KVM_STATS_NAME_SIZE];
>   };
>   


