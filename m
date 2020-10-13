Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24ED228C8B7
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 08:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389635AbgJMGnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 02:43:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57793 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389630AbgJMGnZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Oct 2020 02:43:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602571403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sh/gmJbHrcAyYO0m21LzCsHCpjzZZC38c6UquA+tkIU=;
        b=LLqXPbKl2pnuTvcpfDj/W7+G+AFFI8jHHC/uhZTD/t9KMCjJnzAh5/8n3VIHr/IXnu8NjP
        r5vH+8X2bo0I+IrsCS3i4Tr8eniWiLCP3Fgf6VJuNKYX+ghrgsZc9SSnR2ebpdqty4NNic
        e5ZnMuAYswKq7/Om7LFD2qI8YkWRU3Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-E34LyWquMLW0wZz6r-jj1A-1; Tue, 13 Oct 2020 02:43:22 -0400
X-MC-Unique: E34LyWquMLW0wZz6r-jj1A-1
Received: by mail-wr1-f70.google.com with SMTP id a15so718477wrx.9
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 23:43:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sh/gmJbHrcAyYO0m21LzCsHCpjzZZC38c6UquA+tkIU=;
        b=CiyB8vmJzjcJ90cAIE93amy8cCBqq9dHoWk4WktSvs2j0mT+UJ/tVlxJQReiyKYrh1
         8P3sHLjXu30Ps6yNYdjk0KAdhxzfW8fCQ5KPjf+58WYglPceVf9R6Wb1PZ9ZaKweClgl
         p/0qNg4dQyDVegAgoE9p7wFTj2Ta7y00WC0evLqbutnZP5K4LDmMpjr8VkYlF16sdW4n
         OkX8nzYlA6OmPNp9NZB3FDMxsD6zSyVA1mbtiUY1+nwVRbOxJZUbg18G6tVYjGmTCriR
         IWW3Q6j1oXj5UbU+Ban1ZaoBDNIxZSLDqxTtccCLc3BSa6SNOZ7bwB4LQIPWYbbfu52J
         /8tA==
X-Gm-Message-State: AOAM532VUP4+ZIaTnURjQEr7WxDmuGxM4RKIToQcIJxDt3CVTuWl3wPk
        hzOPFNzpHe585E0gzOXN81fskrvJjxwEBbhXGJJ5MdnjOE3D8aeOLsgVogbfCB/8APpAix40MIA
        91f0BhCxxmZoB
X-Received: by 2002:a1c:2901:: with SMTP id p1mr14380863wmp.170.1602571400470;
        Mon, 12 Oct 2020 23:43:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0EYswdSavfjYuV4awNjUjusOU6B8ETe+iSqQIMt+ZYiNDz/7lg+H3DKt2xnKiFzfD8ji2JQ==
X-Received: by 2002:a1c:2901:: with SMTP id p1mr14380845wmp.170.1602571400238;
        Mon, 12 Oct 2020 23:43:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:61dd:85cb:23fc:fd54? ([2001:b07:6468:f312:61dd:85cb:23fc:fd54])
        by smtp.gmail.com with ESMTPSA id i33sm29149514wri.79.2020.10.12.23.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 23:43:19 -0700 (PDT)
Subject: Re: Why guest physical addresses are not the same as the
 corresponding host virtual addresses in QEMU/KVM? Thanks!
To:     harry harry <hiharryharryharry@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, qemu-devel@nongnu.org,
        mathieu.tarral@protonmail.com, stefanha@redhat.com,
        libvir-list@redhat.com, kvm@vger.kernel.org
References: <CA+-xGqMd4_58_+QKetjOsubBqrDnaYF+YWE3TC3kEcNGxPiPfg@mail.gmail.com>
 <47ead258320536d00f9f32891da3810040875aff.camel@redhat.com>
 <CA+-xGqOm2sWbxR=3W1pWrZNLOt7EE5qiNWxMz=9=gmga15vD2w@mail.gmail.com>
 <20201012165428.GD26135@linux.intel.com>
 <CA+-xGqPkkiws0bxrzud_qKs3ZmKN9=AfN=JGephfGc+2rn6ybw@mail.gmail.com>
 <20201013045245.GA11344@linux.intel.com>
 <CA+-xGqO4DtUs3-jH+QMPEze2GrXwtNX0z=vVUVak5HOpPKaDxQ@mail.gmail.com>
 <CA+-xGqMMa-DB1SND5MRugusDafjNA9CVw-=OBK7q=CK1impmTQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a163c2d8-d8a1-dc03-6230-a2e104e3b039@redhat.com>
Date:   Tue, 13 Oct 2020 08:43:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CA+-xGqMMa-DB1SND5MRugusDafjNA9CVw-=OBK7q=CK1impmTQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/20 07:46, harry harry wrote:
> Now, let's assume array[0]'s GPA is different from its corresponding
> HVA. I think there might be one issue like this: I think MMU's hardware
> logic to translate ``GPA ->[extended/nested page tables] -> HPA''[1]
> should be the same as ``VA-> [page tables] -> PA"[2]; if true, how does
> KVM find the correct HPA with the different HVA (e.g., array[0]'s HVA is
> not  0x0000000000000081) when there are EPT violations?

It has separate data structures that help with the translation.  These
data structures are specific to KVM for GPA to HVA translation, while
for HVA to HPA the Linux functionality is reused.

> BTW, I assume the software logic for KVM to find the HPA with a given
> HVA (as you said like below) should be the same as the hardware logic in
> MMU to translate ``GPA -> [extended/nested page tables] -> HPA''.

No, the logic to find the HPA with a given HVA is the same as the
hardware logic to translate HVA -> HPA.  That is it uses the host
"regular" page tables, not the nested page tables.

In order to translate GPA to HPA, instead, KVM does not use the nested
page tables.  It performs instead two steps, from GPA to HVA and from
HVA to HPA:

* for GPA to HVA it uses a custom data structure.

* for HVA to HPA it uses the host page tables as mentioned above.

This is because:

* the GPA to HVA translation is the one that is almost always
sufficient, and the nested page tables do not provide this information

* even if GPA to HPA is needed, the nested page tables are built lazily
and therefore may not always contain the requested mapping.  In addition
using HPA requires special steps (such as calling get_page/put_page) and
often these steps need an HVA anyway.

Paolo

