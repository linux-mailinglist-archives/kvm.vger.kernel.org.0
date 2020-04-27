Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5CB1BAA53
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 18:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgD0QsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 12:48:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27525 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726162AbgD0QsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 12:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588006094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dzvyJKP9sFMzzye0eBMoLGo9O+kQgOEeNVigizZV/24=;
        b=OXyPJy9ER5PNkkzYFA8/5JJBvyf93k/GXA3w2jYru0y/s4AlXvLtBbRkobjtjzPumNyLhJ
        RJgaCHuJXP397DcJcj06wPwQee2BIMxpLviAIwtTO9IfCYP5EgxrlWpJdhmYb14djRAw0E
        a7/0jydREf49ct2opLK3HLbBr43ruPc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-TPNRZWSCN12xcHomN5q9kA-1; Mon, 27 Apr 2020 12:48:12 -0400
X-MC-Unique: TPNRZWSCN12xcHomN5q9kA-1
Received: by mail-wr1-f69.google.com with SMTP id o8so10314887wrm.11
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 09:48:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dzvyJKP9sFMzzye0eBMoLGo9O+kQgOEeNVigizZV/24=;
        b=XHIy7vtaEcEL6GvPIbcFthOJDgQiwrAv8ckLiKsd/mbV5LbZG2FRv9zSBVZ6cdMW58
         jnaCG/z7lK28S8xxokrsKaoUEIKQy4bcI5Ooukwb6LFvoiohT0gmLqC0d956eTdTmY+a
         boSTxhpZx3N9EISWfvq+qv2LxQahNYuVnv1VdINzAHjsEcsMyhL2W5U3PjcJZ6+GMiY8
         Xd68+0t1O6+oIU++Hdq0w1XJ1hSac+OfS+dMfrOICCQ4dq12ayP9MykJsXv3TkLxdstT
         P3DsIOeeCoIsO5rQ59JBs/wmREbGhLx5g9eHYS6dYtdBriXS/8xk1ddmXYxFV90T1J5A
         VlmQ==
X-Gm-Message-State: AGi0PuZPOYfKNGasvGywRUvTcearOqoJwTK7oZoe1tiD1nyfIY7IXQtn
        3Ce6kiMs0+kqBuykQdS8VOE2rmeGx9P0fU9Iqpsoh+uOlrwtcH2+E1DitWZc3MNEBSVz5zUgkJp
        KFsDizRbJUhdT
X-Received: by 2002:a7b:c0cb:: with SMTP id s11mr424177wmh.180.1588006091254;
        Mon, 27 Apr 2020 09:48:11 -0700 (PDT)
X-Google-Smtp-Source: APiQypKQldDOg4XMxcMvhhvMfcF5U+o+47DECk6OwdzYlN9FGGKmfQMvYtHlayyVpge/M4KA58Ag+g==
X-Received: by 2002:a7b:c0cb:: with SMTP id s11mr424157wmh.180.1588006091060;
        Mon, 27 Apr 2020 09:48:11 -0700 (PDT)
Received: from localhost.localdomain ([194.230.155.207])
        by smtp.gmail.com with ESMTPSA id z8sm20576538wrr.40.2020.04.27.09.48.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 09:48:10 -0700 (PDT)
Subject: Re: [RFC PATCH 2/5] statsfs API: create, add and remove statsfs
 sources and values
To:     Matthew Wilcox <willy@infradead.org>
Cc:     kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, mst@redhat.com,
        borntraeger@de.ibm.com, Paolo Bonzini <pbonzini@redhat.com>
References: <20200427141816.16703-1-eesposit@redhat.com>
 <20200427141816.16703-3-eesposit@redhat.com>
 <20200427154727.GH29705@bombadil.infradead.org>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-ID: <116c9fff-02c1-ddb4-feab-d836c79b1373@redhat.com>
Date:   Mon, 27 Apr 2020 18:48:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200427154727.GH29705@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/27/20 5:47 PM, Matthew Wilcox wrote:
> On Mon, Apr 27, 2020 at 04:18:13PM +0200, Emanuele Giuseppe Esposito wrote:
>> +static struct statsfs_value *find_value(struct statsfs_value_source *src,
>> +					struct statsfs_value *val)
>> +{
>> +	struct statsfs_value *entry;
>> +
>> +	for (entry = src->values; entry->name; entry++) {
>> +		if (entry == val) {
>> +			WARN_ON(strcmp(entry->name, val->name) != 0);
> 
> Umm.  'entry' and 'val' are pointers.  So if entry is equal to val,
> how could entry->name and val->name not be the same thing?

Good catch, I'll get rid of that check.
> 
> 
> +int statsfs_source_add_values(struct statsfs_source *source,
> +			      struct statsfs_value *stat, void *ptr)
> +{
> +	struct statsfs_value_source *entry, *val_src;
> +	unsigned long index;
> +	int err = -EEXIST;
> +
> +	val_src = create_value_source(ptr);
> +	val_src->values = stat;
> +
> +	xa_lock(&source->values);
> +	xa_for_each(&source->values, index, entry) {
> +		if (entry->base_addr == ptr && entry->values == stat)
> +			goto out;
> +	}
> +
> +	err = __xa_alloc(&source->values, &val_src->id, val_src, xa_limit_32b,
> +			GFP_KERNEL);
> +out:
> +	xa_unlock(&source->values);
> +	if (err)
> +		kfree(val_src);
> +	return err;
> +}
> 
> Using an XArray avoids the occasional latency problems you can see with
> rwsems, as well as being more cache-effective than a linked list.

I didn't know about XArrays, I'll give them a look. I will also fix the 
list initialization with INIT_LIST_HEAD.

Thank you for the above example, but I don't think that each source 
would have more than 2 or 3 value_sources, so using a linked list there 
should be fine.
However, this might be a good point for the subordinates list.

Regarding the locking, the rwsem is also used to protect the other 
lists and dentry of the source, so it wouldn't be removed anyways.

Thank you,

Emanuele

