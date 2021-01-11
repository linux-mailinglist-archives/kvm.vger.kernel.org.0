Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E45C2F1D72
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 19:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389210AbhAKSGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 13:06:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52510 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727030AbhAKSGI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Jan 2021 13:06:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610388281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YDFmgDgRxNAaH6RohnUOtmiFzfn10DX+8iq8uU5yc/I=;
        b=CJxnkNXvH84OkSUa4wDPCjAVaozZ+Zekt64TwKbsM4nxt8Vq0aSJbC5mjF+b6iAETtg5sd
        rT8tguDcFWgpBx2ZdraTtpRyjCNNwKCSSk6TgJM2VfyBd2SUpC6yX74lycfldqTmEI6aSP
        +Yah4VlDnMgL+y5VgHp3dW1tahAt/JI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-J4N8intHOCKhgS4lRCw6-g-1; Mon, 11 Jan 2021 13:04:40 -0500
X-MC-Unique: J4N8intHOCKhgS4lRCw6-g-1
Received: by mail-ed1-f71.google.com with SMTP id dh21so54109edb.6
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 10:04:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YDFmgDgRxNAaH6RohnUOtmiFzfn10DX+8iq8uU5yc/I=;
        b=TDRfggyxxF7Zl2ICzsNi+vRRnJRM9jKNSbCit5zQpl5Jzq+wz1W/YozbJeTEYsxG6a
         3j5/aKjZY+qwQ/59JQNsujZn8Q4nhh26dYKsy1j92UcaGaU9ZLpVYRp1OzeFwiS6JxCo
         WHU5hpROHdJXdphX3Ohw63LugIz6N9X4R/ivt2Xm+Sxb7u8vntOb5c5sp8Wqjw8Hmpi7
         AYBbw9xpLELRcLc1kbvBjh/veBxP3P4TOnm2HxiAdgezFN85xfBPq3GNszsVzGeRhN5B
         ivGwESdrj+nEzrHN8jdUIM+R9SAD046jOb5EeURD6PNN7rgvLzJ3QlK0VOqbO2Qc75kw
         VP7g==
X-Gm-Message-State: AOAM531WSoREkBIGn+H5oPhH6hoCuWpA4AxB7/YeE5OeubnWn6ROyAk5
        YXQ02QtvxsYlCPeQZuhhTKlnPt2GBX2GTAgB/7A8Nliqzf+3YWr7lNACPCQYMDNKMkfjcPSfiwe
        znWjEDHbUK2Ol
X-Received: by 2002:a17:906:e206:: with SMTP id gf6mr485199ejb.342.1610388278594;
        Mon, 11 Jan 2021 10:04:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz/eIATFh+PBzF3J4BtSB/ymjE8fFcXELl6KOECpzo5ZQ+s0HAQLJXiUQrwWyl4CzkEtxKzhA==
X-Received: by 2002:a17:906:e206:: with SMTP id gf6mr485177ejb.342.1610388278343;
        Mon, 11 Jan 2021 10:04:38 -0800 (PST)
Received: from [192.168.1.36] (129.red-88-21-205.staticip.rima-tde.net. [88.21.205.129])
        by smtp.gmail.com with ESMTPSA id n16sm273664edq.62.2021.01.11.10.04.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 10:04:37 -0800 (PST)
Subject: Re: [for-6.0 v5 01/13] qom: Allow optional sugar props
To:     David Gibson <david@gibson.dropbear.id.au>, pair@us.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, brijesh.singh@amd.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org
Cc:     thuth@redhat.com, cohuck@redhat.com, berrange@redhat.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, david@redhat.com,
        mdroth@linux.vnet.ibm.com, Greg Kurz <groug@kaod.org>,
        pasic@linux.ibm.com, borntraeger@de.ibm.com, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, rth@twiddle.net
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <20201204054415.579042-2-david@gibson.dropbear.id.au>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <380065a5-f656-6f4b-edfe-ce9199f8bc62@redhat.com>
Date:   Mon, 11 Jan 2021 19:04:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201204054415.579042-2-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/4/20 6:44 AM, David Gibson wrote:
> From: Greg Kurz <groug@kaod.org>
> 
> Global properties have an @optional field, which allows to apply a given
> property to a given type even if one of its subclasses doesn't support
> it. This is especially used in the compat code when dealing with the
> "disable-modern" and "disable-legacy" properties and the "virtio-pci"
> type.
> 
> Allow object_register_sugar_prop() to set this field as well.
> 
> Signed-off-by: Greg Kurz <groug@kaod.org>
> Message-Id: <159738953558.377274.16617742952571083440.stgit@bahia.lan>
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  include/qom/object.h |  3 ++-
>  qom/object.c         |  4 +++-
>  softmmu/vl.c         | 16 ++++++++++------
>  3 files changed, 15 insertions(+), 8 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

