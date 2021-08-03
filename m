Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD583DE728
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 09:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbhHCHW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 03:22:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46642 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233966AbhHCHW4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 03:22:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627975365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vvnHHx5SLZ5txIch7uBR/ScqaaZaH/q4GjsYjYEelMc=;
        b=LX/YbR149PDUz17kYjEZtvbOXE1pH555q+C/Ewrxq25ypgPkm3jXv3RzVUZ1mK9TzbqwLa
        eQ8tk3owFNU4cLUlQqQ3HBg6huDgInoVoDLrc+U2g9mY9bpMA1P6CHXPYCkhv2HnU51Pjs
        8p8zRx2+KoiUAtcdKo7bYKUPr8VoN30=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-_ttXy6QUN223SR2HKK3afg-1; Tue, 03 Aug 2021 03:22:44 -0400
X-MC-Unique: _ttXy6QUN223SR2HKK3afg-1
Received: by mail-wr1-f70.google.com with SMTP id a9-20020a0560000509b029015485b95d0cso1659570wrf.5
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 00:22:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vvnHHx5SLZ5txIch7uBR/ScqaaZaH/q4GjsYjYEelMc=;
        b=ImPCDe5LSxn9X/Af6K78/PshKAdJMLxBmkgrnd1xYm3zRxofaSB538D9CvO2l3/qaC
         6XJ5xUsyEraI4QOqoXUTQWgL0jNzucn2Yh/mNkejHC/liGbidK8yxHkIsLhPH/ndFA5B
         /Y92Hprjm40/1f8vMI1kzfvdXS7cktDJDY43w6YLJ1hn//JeAUyGrSlEqjVYkVyNxRZl
         jo9NZAjec1aPpLIMp23yiZzMYpfCH2kMm0nlDT6oNE1+UTX6HUswfs2U4mQXFnsFKlPU
         Y6gdTXqy9g+ilGy6f4v7XstEd375GrzkSfeakrE3tyUX7Bs9pC7PAC/TBAqMPW4Q1M7q
         K16g==
X-Gm-Message-State: AOAM530P2kWpshJcK3j75bc3XD3oe51kKgvL9FowKKeiIs3HA6ZD/Zjb
        OKu5w2s9KVWaC/XZYoz6IW0BQUHayg8aMrs75rui+3IqAZfTA1LZ7iahp3Vz2d9LN4KtwvX20o0
        KzpP4YO159a3p
X-Received: by 2002:a1c:7f50:: with SMTP id a77mr20328713wmd.163.1627975363072;
        Tue, 03 Aug 2021 00:22:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+tgS1Mk8R2aPdLRZYExFRWj4Yx3qDfpTy+W7fwabL4DjFpr/pDuM96T7v5V0HkrgnPGd44w==
X-Received: by 2002:a1c:7f50:: with SMTP id a77mr20328690wmd.163.1627975362815;
        Tue, 03 Aug 2021 00:22:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id w5sm15777146wro.45.2021.08.03.00.22.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 00:22:42 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: SVM: improve the code readability for ASID
 management
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Alper Gun <alpergun@google.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Peter Gonda <pgonda@google.com>
References: <20210802180903.159381-1-mizhang@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a737d476-05dc-5aea-99ec-8960fcb9fc2f@redhat.com>
Date:   Tue, 3 Aug 2021 09:22:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802180903.159381-1-mizhang@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/21 20:09, Mingwei Zhang wrote:
> KVM SEV code uses bitmaps to manage ASID states. ASID 0 was always skipped
> because it is never used by VM. Thus, in existing code, ASID value and its
> bitmap postion always has an 'offset-by-1' relationship.
> 
> Both SEV and SEV-ES shares the ASID space, thus KVM uses a dynamic range
> [min_asid, max_asid] to handle SEV and SEV-ES ASIDs separately.
> 
> Existing code mixes the usage of ASID value and its bitmap position by
> using the same variable called 'min_asid'.
> 
> Fix the min_asid usage: ensure that its usage is consistent with its name;
> allocate extra size for ASID 0 to ensure that each ASID has the same value
> with its bitmap position. Add comments on ASID bitmap allocation to clarify
> the size change.
> 
> v1 -> v2:
>   - change ASID bitmap size to incorporate ASID 0 [sean]
>   - remove the 'fixes' line in commit message. [sean/joerg]
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Alper Gun <alpergun@google.com>
> Cc: Dionna Glaze <dionnaglaze@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vipin Sharma <vipinsh@google.com>
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> ---
>   arch/x86/kvm/svm/sev.c | 36 +++++++++++++++++++++---------------
>   1 file changed, 21 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 8d36f0c73071..42d46c30f313 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -63,6 +63,7 @@ static DEFINE_MUTEX(sev_bitmap_lock);
>   unsigned int max_sev_asid;
>   static unsigned int min_sev_asid;
>   static unsigned long sev_me_mask;
> +static unsigned int nr_asids;
>   static unsigned long *sev_asid_bitmap;
>   static unsigned long *sev_reclaim_asid_bitmap;
>   
> @@ -77,11 +78,11 @@ struct enc_region {
>   /* Called with the sev_bitmap_lock held, or on shutdown  */
>   static int sev_flush_asids(int min_asid, int max_asid)
>   {
> -	int ret, pos, error = 0;
> +	int ret, asid, error = 0;
>   
>   	/* Check if there are any ASIDs to reclaim before performing a flush */
> -	pos = find_next_bit(sev_reclaim_asid_bitmap, max_asid, min_asid);
> -	if (pos >= max_asid)
> +	asid = find_next_bit(sev_reclaim_asid_bitmap, nr_asids, min_asid);
> +	if (asid > max_asid)
>   		return -EBUSY;
>   
>   	/*
> @@ -114,15 +115,15 @@ static bool __sev_recycle_asids(int min_asid, int max_asid)
>   
>   	/* The flush process will flush all reclaimable SEV and SEV-ES ASIDs */
>   	bitmap_xor(sev_asid_bitmap, sev_asid_bitmap, sev_reclaim_asid_bitmap,
> -		   max_sev_asid);
> -	bitmap_zero(sev_reclaim_asid_bitmap, max_sev_asid);
> +		   nr_asids);
> +	bitmap_zero(sev_reclaim_asid_bitmap, nr_asids);
>   
>   	return true;
>   }
>   
>   static int sev_asid_new(struct kvm_sev_info *sev)
>   {
> -	int pos, min_asid, max_asid, ret;
> +	int asid, min_asid, max_asid, ret;
>   	bool retry = true;
>   	enum misc_res_type type;
>   
> @@ -142,11 +143,11 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>   	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
>   	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
>   	 */
> -	min_asid = sev->es_active ? 0 : min_sev_asid - 1;
> +	min_asid = sev->es_active ? 1 : min_sev_asid;
>   	max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
>   again:
> -	pos = find_next_zero_bit(sev_asid_bitmap, max_sev_asid, min_asid);
> -	if (pos >= max_asid) {
> +	asid = find_next_zero_bit(sev_asid_bitmap, max_sev_asid, min_asid);
> +	if (asid > max_asid) {
>   		if (retry && __sev_recycle_asids(min_asid, max_asid)) {
>   			retry = false;
>   			goto again;
> @@ -156,11 +157,11 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>   		goto e_uncharge;
>   	}
>   
> -	__set_bit(pos, sev_asid_bitmap);
> +	__set_bit(asid, sev_asid_bitmap);
>   
>   	mutex_unlock(&sev_bitmap_lock);
>   
> -	return pos + 1;
> +	return asid;
>   e_uncharge:
>   	misc_cg_uncharge(type, sev->misc_cg, 1);
>   	put_misc_cg(sev->misc_cg);
> @@ -1854,12 +1855,17 @@ void __init sev_hardware_setup(void)
>   	min_sev_asid = edx;
>   	sev_me_mask = 1UL << (ebx & 0x3f);
>   
> -	/* Initialize SEV ASID bitmaps */
> -	sev_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
> +	/*
> +	 * Initialize SEV ASID bitmaps. Allocate space for ASID 0 in the bitmap,
> +	 * even though it's never used, so that the bitmap is indexed by the
> +	 * actual ASID.
> +	 */
> +	nr_asids = max_sev_asid + 1;
> +	sev_asid_bitmap = bitmap_zalloc(nr_asids, GFP_KERNEL);
>   	if (!sev_asid_bitmap)
>   		goto out;
>   
> -	sev_reclaim_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
> +	sev_reclaim_asid_bitmap = bitmap_zalloc(nr_asids, GFP_KERNEL);
>   	if (!sev_reclaim_asid_bitmap) {
>   		bitmap_free(sev_asid_bitmap);
>   		sev_asid_bitmap = NULL;
> @@ -1904,7 +1910,7 @@ void sev_hardware_teardown(void)
>   		return;
>   
>   	/* No need to take sev_bitmap_lock, all VMs have been destroyed. */
> -	sev_flush_asids(0, max_sev_asid);
> +	sev_flush_asids(1, max_sev_asid);
>   
>   	bitmap_free(sev_asid_bitmap);
>   	bitmap_free(sev_reclaim_asid_bitmap);
> 

Queued, thanks.

Paolo

