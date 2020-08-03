Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A91E23AC3D
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 20:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbgHCSSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 14:18:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49206 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727076AbgHCSSy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Aug 2020 14:18:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596478733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yPKDeMAAn3g8NgJRsWCV0tXrMbTpTCdEV09ubLsqzjc=;
        b=IUVa+6DprU5zZnB2RBToqW62WxjKSt+5UOS38b/rO5sLwNU7h+jaGOy0FSRUwfIsvRn0YQ
        qVMxhZUdpewrDa66YMruitgPrvoPHr3fCDeTLmOkHnYkxeHF2aX93q7OCEOQS7FY2HcXY1
        EKi/KMcdoBcokAlSEcYCcTgxEueSXBg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-rsjf4nhjMoWYT0NpxhGl_w-1; Mon, 03 Aug 2020 14:18:52 -0400
X-MC-Unique: rsjf4nhjMoWYT0NpxhGl_w-1
Received: by mail-wm1-f72.google.com with SMTP id c124so103787wme.0
        for <kvm@vger.kernel.org>; Mon, 03 Aug 2020 11:18:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yPKDeMAAn3g8NgJRsWCV0tXrMbTpTCdEV09ubLsqzjc=;
        b=VMD4LzGM8Tm4lLrZHJ6dv7VlYngDU+XGg4Ew7iayAFAA9A3bbq5Xd2LZSUQLZeizZ/
         2L0t0RyatptCPX2qbUrb9YONKNPEWP6eHWDVIoF0ySRuhzQrQdBPuHaz3j8G2eAYVTY7
         M+4tiMzL92ih2N7tpCti8DMCCMz02ZN3Q05B54N7xmgdpqQSDOa6vWik0yBQNSzyJpD2
         IN3rQRIUvmj/4IgUIq1dMvb9DOpDsxxtYJWxa38KDLuqjxlLnEpWqwlrBqr2bEQ4Ygnd
         4Z2DnBRFi2k+yevCWhQJy+Z45SxUoes0GBLFrBji0gcAGsRtgYbE33nvoWEAUwFUBjjS
         6qtw==
X-Gm-Message-State: AOAM533RdHFPtafKfJ9+ocJe+6bWaAoJ0cMz1bXTLeB0ZA2CK3V/ERYI
        eHrbkMJEagZar8YYFw0b5LfTNNDmJFaqNnTbLxRPq09aE99LINBSfa2lDNuX1OeUVNZn8dPezfr
        WpqjPDGcG0SGV
X-Received: by 2002:a1c:a3c4:: with SMTP id m187mr397245wme.43.1596478731219;
        Mon, 03 Aug 2020 11:18:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGD9HBEfhlRLyGlm/2kLSdE4Zk4T6dBgmZJE1M6Fy+nfUqrm4TvyTkpuhyCUN5QEnwNLqf6Q==
X-Received: by 2002:a1c:a3c4:: with SMTP id m187mr397234wme.43.1596478731015;
        Mon, 03 Aug 2020 11:18:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7841:78cc:18c6:1e20? ([2001:b07:6468:f312:7841:78cc:18c6:1e20])
        by smtp.gmail.com with ESMTPSA id y203sm694574wmc.29.2020.08.03.11.18.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 11:18:50 -0700 (PDT)
Subject: Re: [GIT PULL 0/2] KVM: s390: feature for 5.9
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Collin Walling <walling@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
References: <20200730094857.175501-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cfdecb8b-726c-63ae-8438-5f9c7338435f@redhat.com>
Date:   Mon, 3 Aug 2020 20:18:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200730094857.175501-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/20 11:48, Christian Borntraeger wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.9-1

Pulled, thanks.

Paolo

