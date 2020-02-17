Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5AE161084
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 12:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgBQK77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 05:59:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53657 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726267AbgBQK77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 05:59:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581937198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=4LtbxmY14VvP+7JT8s/h/gdL8Ybt0EjctXKukQdkcGw=;
        b=B4r97uLtSWVxjYbmK9tluFcaUV41AzvEwJvg6v5TRqSG8bGYr8MfO9QGBp1mQN2j00oJjL
        uTWWgZOkdTqToUVhqD2A3vfSwtrxGU/1V5l9zq4YjDXJVSnttVXKv4AUF6e6Vtr9Tv05Mo
        ESb9+Srdku9/3BP1A0bzeIxecxijYrY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-ebrjW23OOWeQIHXTGy6l4g-1; Mon, 17 Feb 2020 05:59:56 -0500
X-MC-Unique: ebrjW23OOWeQIHXTGy6l4g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74FB81005512;
        Mon, 17 Feb 2020 10:59:54 +0000 (UTC)
Received: from [10.36.117.64] (ovpn-117-64.ams2.redhat.com [10.36.117.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BC222CC39;
        Mon, 17 Feb 2020 10:59:48 +0000 (UTC)
Subject: Re: [PATCH v2 15/42] KVM: s390: protvirt: Add interruption injection
 controls
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
 <20200214222658.12946-16-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <f5122739-bf1d-3e10-3953-c2b3487cc91a@redhat.com>
Date:   Mon, 17 Feb 2020 11:59:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214222658.12946-16-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.02.20 23:26, Christian Borntraeger wrote:
> From: Michael Mueller <mimu@linux.ibm.com>
> 
> This defines the necessary data structures in the SIE control block to
> inject machine checks,external and I/O interrupts. We first define the
> the interrupt injection control, which defines the next interrupt to
> inject. Then we define the fields that contain the payload for machine
> checks,external and I/O interrupts
> 
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h | 56 +++++++++++++++++++++++++-------
>  1 file changed, 44 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index c6694f47b73b..834b3b7a6e23 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -222,7 +222,15 @@ struct kvm_s390_sie_block {
>  	__u8	icptcode;		/* 0x0050 */
>  	__u8	icptstatus;		/* 0x0051 */
>  	__u16	ihcpu;			/* 0x0052 */
> -	__u8	reserved54[2];		/* 0x0054 */
> +	__u8	reserved54;		/* 0x0054 */
> +#define IICTL_CODE_NONE		 0x00
> +#define IICTL_CODE_MCHK		 0x01
> +#define IICTL_CODE_EXT		 0x02
> +#define IICTL_CODE_IO		 0x03
> +#define IICTL_CODE_RESTART	 0x04
> +#define IICTL_CODE_SPECIFICATION 0x10
> +#define IICTL_CODE_OPERAND	 0x11
> +	__u8	iictl;			/* 0x0055 */
>  	__u16	ipa;			/* 0x0056 */
>  	__u32	ipb;			/* 0x0058 */
>  	__u32	scaoh;			/* 0x005c */
> @@ -259,24 +267,48 @@ struct kvm_s390_sie_block {
>  #define HPID_KVM	0x4
>  #define HPID_VSIE	0x5
>  	__u8	hpid;			/* 0x00b8 */
> -	__u8	reservedb9[11];		/* 0x00b9 */
> -	__u16	extcpuaddr;		/* 0x00c4 */
> -	__u16	eic;			/* 0x00c6 */
> +	__u8	reservedb9[7];		/* 0x00b9 */
> +	union {
> +		struct {
> +			__u32	eiparams;	/* 0x00c0 */
> +			__u16	extcpuaddr;	/* 0x00c4 */
> +			__u16	eic;		/* 0x00c6 */
> +		};
> +		__u64	mcic;			/* 0x00c0 */
> +	} __packed;
>  	__u32	reservedc8;		/* 0x00c8 */
> -	__u16	pgmilc;			/* 0x00cc */
> -	__u16	iprcc;			/* 0x00ce */
> -	__u32	dxc;			/* 0x00d0 */
> -	__u16	mcn;			/* 0x00d4 */
> -	__u8	perc;			/* 0x00d6 */
> -	__u8	peratmid;		/* 0x00d7 */
> +	union {
> +		struct {
> +			__u16	pgmilc;		/* 0x00cc */
> +			__u16	iprcc;		/* 0x00ce */
> +		};
> +		__u32	edc;			/* 0x00cc */
> +	} __packed;
> +	union {
> +		struct {
> +			__u32	dxc;		/* 0x00d0 */
> +			__u16	mcn;		/* 0x00d4 */
> +			__u8	perc;		/* 0x00d6 */
> +			__u8	peratmid;	/* 0x00d7 */
> +		};
> +		__u64	faddr;			/* 0x00d0 */
> +	} __packed;
>  	__u64	peraddr;		/* 0x00d8 */
>  	__u8	eai;			/* 0x00e0 */
>  	__u8	peraid;			/* 0x00e1 */
>  	__u8	oai;			/* 0x00e2 */
>  	__u8	armid;			/* 0x00e3 */
>  	__u8	reservede4[4];		/* 0x00e4 */
> -	__u64	tecmc;			/* 0x00e8 */
> -	__u8	reservedf0[12];		/* 0x00f0 */
> +	union {
> +		__u64	tecmc;		/* 0x00e8 */
> +		struct {
> +			__u16	subchannel_id;	/* 0x00e8 */
> +			__u16	subchannel_nr;	/* 0x00ea */
> +			__u32	io_int_parm;	/* 0x00ec */
> +			__u32	io_int_word;	/* 0x00f0 */
> +		};
> +	} __packed;
> +	__u8	reservedf4[8];		/* 0x00f4 */
>  #define CRYCB_FORMAT_MASK 0x00000003
>  #define CRYCB_FORMAT0 0x00000000
>  #define CRYCB_FORMAT1 0x00000001
> 

I'd just squash that into the patch where it is actually used. (IOW, the
next one)

-- 
Thanks,

David / dhildenb

