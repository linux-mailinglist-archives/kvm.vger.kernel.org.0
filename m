Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E7B1B2811
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 15:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgDUNgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 09:36:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41641 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728479AbgDUNgx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 09:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587476211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wCsZ3VGNPNsrXjnUXsD0UNS2OD+KJF3obERZuUYiksw=;
        b=RqG4cNUILPS4r643ibAKOST13JTLpWdUU25Afa5PnLcQEyWiJ9dY2Ol8UphF6ZFS85ECOP
        l3zPUnJpIO2NgEgBXzByRsg81q133A94ScgoetgM6zZrOpeOky5pRNW46HwIBn4GfruFMv
        Ug49NlnoQ5Up0TcaBea8RrFJlK0vxAI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-8qm_BgOvOiSUxFSnnUJ8KQ-1; Tue, 21 Apr 2020 09:36:50 -0400
X-MC-Unique: 8qm_BgOvOiSUxFSnnUJ8KQ-1
Received: by mail-wr1-f71.google.com with SMTP id x15so5479349wrn.0
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 06:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wCsZ3VGNPNsrXjnUXsD0UNS2OD+KJF3obERZuUYiksw=;
        b=mihFkPRenFdT+KLqr27Kb8ieOvNEsCSqPgAiiwZnfCy9nCQuoRhW/ctQHwRTjHKbKY
         A4YUslauKK0Ak27pxsON9rRJM3fSI9pDcjyNbCnZtQ8vFJ6/HjHJMxi8ex+uHYMtLmuC
         P+PK9qfYYsGO3HCsGpm9TQOq628uJ4hID2vFINyElUQYCyAr5e9z41qEJgtz/XEvE9Mf
         FOC2LfrWJq0YgHOkd8cFFcCPbNyuumLkIf1LVBgfVdvL8LoymkvBDtHfn9gGYFUlHOAq
         ohvewS8uu0Oup7/fhj6xy3ePqxVqaSELCkGai7btvgwfoKdvqFyx5FfQZegfwRbSye2z
         Q3dA==
X-Gm-Message-State: AGi0PuZpENVgnJC5534EOIF0/htPifbxvMTT3fOkQ1J2B+KVlF5Iqu7R
        Wvxste9CS4cfGWOomYrWSYc2LxwBOyToKlB7f187fyfLJAMrnC1A3EADpn79Gmof6tkR2Qwaxeu
        XBBUCkkFnyDSm
X-Received: by 2002:adf:fe87:: with SMTP id l7mr25844142wrr.360.1587476207976;
        Tue, 21 Apr 2020 06:36:47 -0700 (PDT)
X-Google-Smtp-Source: APiQypKlJhAt+4JVl6zumdVZp9Pr5ZIy7Ugt0KD1kpUHwKm7tmzB+uo/O5wVy1Oz0VXjIEvE1GjbyQ==
X-Received: by 2002:adf:fe87:: with SMTP id l7mr25844113wrr.360.1587476207729;
        Tue, 21 Apr 2020 06:36:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id h3sm3705930wrm.73.2020.04.21.06.36.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 06:36:47 -0700 (PDT)
Subject: Re: [GIT PULL 0/2] KVM: s390: Fix for 5.7 and maintainer update
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20200421063447.6814-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <173f3395-1289-2c38-1afa-f6180e802c84@redhat.com>
Date:   Tue, 21 Apr 2020 15:36:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200421063447.6814-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/20 08:34, Christian Borntraeger wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.7-2

Pulled, thanks.

Paolo

