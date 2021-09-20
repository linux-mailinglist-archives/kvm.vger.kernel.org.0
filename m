Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BC8411726
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 16:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbhITOfI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 10:35:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29827 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237336AbhITOfH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 10:35:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632148420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yBsCvbW6RE9n5W/GL0VsnAi+BXoI7Pwb+bRrHkSdRBs=;
        b=csvDN8lB78a2kuyNMc9n+nRj5Jr59iyWPGmUTLKA80klc00tDYkFmUp6awTPg15iqhiPLr
        YdwllLihjIBk0CJCk8l9E4a2p1BR27APl/bM+Iq7utrBB5AK+vvR2cYGUS4JOdf9/TEWM/
        hKx/wzLTxWcd/f33JfKcJthE/ZFRWiw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-KMvVTj8NO2-z5hcC70r89g-1; Mon, 20 Sep 2021 10:33:39 -0400
X-MC-Unique: KMvVTj8NO2-z5hcC70r89g-1
Received: by mail-ed1-f69.google.com with SMTP id o23-20020a509b17000000b003d739e2931dso14150999edi.4
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 07:33:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yBsCvbW6RE9n5W/GL0VsnAi+BXoI7Pwb+bRrHkSdRBs=;
        b=0W6ZUwc8oUrg4dLcTT0LHjd1JimcN/8TdTsiDE7yLS2LEG2pu7TJNOAsKNh2dEt63Q
         mhuW93bResSJ936yEkrZTVm3ujfABb/B48NDkhLYb/cIyuEhMOwlObjsjZXf8QfILO8w
         xoST4yVYpI3kxcuyRoRKkQZN+M/najynB03Ir4SwXO6YxAhEncbhURLY9qGv7Y3z5QOk
         IK/vsDznZf1FIg2pQUMSWCeyIA/pV5mNw7qvtitRRgPvWfjBIfeuyLfFUxxOmcNfrSl2
         JVlmw2eD7KJ2GtSCIBTroZSndd3ndnSpL4hNMkeqJQFzIjpWTwBN2oyw9RJTtEWV9uqf
         VDmA==
X-Gm-Message-State: AOAM531G4eRJcOh97uUxQw/VKEPy81iuXuwSSJQPq/VtcKDEfyjYhM79
        Ke+TOlSUIfHGmSCxX/VYzvjtHL1OLhNNOSAx4l0BbUxLXaeDDDRTk/O5qe62edaFg/MHBXpl9KE
        B7RjGjM6/rquj
X-Received: by 2002:a05:6402:1ac5:: with SMTP id ba5mr29698453edb.20.1632148418276;
        Mon, 20 Sep 2021 07:33:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6g+GyZvmdWAxkwMMs4CHIychJwpWS3W1R6jFQaMKScgmYjnQs6ZJUoySrNZ0edgRsYiA85g==
X-Received: by 2002:a05:6402:1ac5:: with SMTP id ba5mr29698432edb.20.1632148418097;
        Mon, 20 Sep 2021 07:33:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r26sm6229313ejd.85.2021.09.20.07.33.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 07:33:37 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 01/17] x86 UEFI: Copy code from Linux
To:     Zixuan Wang <zixuanwang@google.com>, kvm@vger.kernel.org,
        drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-2-zixuanwang@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0f423c39-a04d-160e-b3b8-488029080050@redhat.com>
Date:   Mon, 20 Sep 2021 16:33:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210827031222.2778522-2-zixuanwang@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/21 05:12, Zixuan Wang wrote:
> +
> +/*
> + * The UEFI spec and EDK2 reference implementation both define EFI_GUID as
> + * struct { u32 a; u16; b; u16 c; u8 d[8]; }; and so the implied alignment
> + * is 32 bits not 8 bits like our guid_t. In some cases (i.e., on 32-bit ARM),
> + * this means that firmware services invoked by the kernel may assume that
> + * efi_guid_t* arguments are 32-bit aligned, and use memory accessors that
> + * do not tolerate misalignment. So let's set the minimum alignment to 32 bits.

Here you're not doing that though.

Paolo

> + * Note that the UEFI spec as well as some comments in the EDK2 code base
> + * suggest that EFI_GUID should be 64-bit aligned, but this appears to be
> + * a mistake, given that no code seems to exist that actually enforces that
> + * or relies on it.
> + */
> +typedef struct {
> +	u8 b[16];
> +} guid_t;
> +typedef guid_t efi_guid_t;
> +

