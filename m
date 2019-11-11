Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDE4F7537
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfKKNkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:40:36 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38702 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726902AbfKKNkf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 08:40:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573479634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=J4sjOMKeZhlxB4e7qmO5hPjQnxzgkFTkjY92vfzlPNM=;
        b=GF4EXjqFW3xlpqa2o3B5k3OgncJw3BcK6VndmbKIEjYX0aMT3glhLyG6M2GUXC89t2pqxL
        nnmb47cwQjvMGPJOxWXhkXAlaomMAXneCKp1HBaRUiy7+SsdnsP2mFrNitzftgGXc17Bya
        DLbN4L0eY1kj4P9EgaVEep3o0vqyLiU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-Misk9GiONi6odtoiE0T6vA-1; Mon, 11 Nov 2019 08:40:31 -0500
Received: by mail-wr1-f72.google.com with SMTP id y1so2804134wrl.0
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 05:40:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OGr+IbAvKLpk58OWMG+e4ZK8hqNnAEl+rtUI51NG81M=;
        b=ptH3tyZozksPjpUlOVmwWb2kVRdgHSx2EM+MxrK8TO1xSf5NnJLCKQHWcu3Eq7KVfi
         8Lz8bdg3OVCHvdPjf+oleNTQwO0RLEK8z/h9hcpmpmRvrXtlyZidmYFLkMwhtJd6ElEO
         be2lyJOqhPjPJZi+bd59uL/BguuO4P8UUYvKutT466R1DWwZuuBi6YDwX/oIbXL+YLfs
         hlKGfh9sWt6wxksvmjQaJNJ8HEubX7r7LpKi4FnTD0XM8z12JzHYd7o2HKV+Rp+2NvXJ
         ybRiyO3WW4Shpp04RSwB2CVaynkL5J6YndRsiyXfU6SAEvgZMyZuSvnKz7QMSzDpl09d
         IOlw==
X-Gm-Message-State: APjAAAVGhIP+N4f3c/yX5XaHPrni9Ag/eQQkJ9Iktec90pHtWpTpJ35b
        fyQdrAZQsNKyX0T7ZHpAjbzzBHSDTn0hMIsYgOPJX9C22c1q0JUxxaLw9f2jjI5cp/96hgYlPw4
        BHzL/E0IguN3M
X-Received: by 2002:adf:f010:: with SMTP id j16mr16452929wro.206.1573479630551;
        Mon, 11 Nov 2019 05:40:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqwh/fSHm64WGgDol1lwcJreg11XFxj3l8FmPRxzBUSuFydpSvcVZgsoXzk1ugUYIrnxsWlruw==
X-Received: by 2002:adf:f010:: with SMTP id j16mr16452902wro.206.1573479630305;
        Mon, 11 Nov 2019 05:40:30 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id t29sm20461271wrb.53.2019.11.11.05.40.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 05:40:29 -0800 (PST)
Subject: Re: [PATCH 0/2] KVM: x86: Fix userspace API regarding latched init
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com
References: <20191111091640.92660-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <063585db-b835-bff8-9c4f-2f756908f1f1@redhat.com>
Date:   Mon, 11 Nov 2019 14:40:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111091640.92660-1-liran.alon@oracle.com>
Content-Language: en-US
X-MC-Unique: Misk9GiONi6odtoiE0T6vA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 10:16, Liran Alon wrote:
> Hi,
> This patch series aims to fix 2 issue in KVM userspace API regarding latc=
hed init.
>=20
> 1st patch makes sure that userspace can get/set latched_init state
> regardless of if vCPU is in SMM state.
>=20
> 2nd patch prevents userspace from setting vCPU in INIT_RECEIVED/SIPI_RECE=
IVED
> state in case vCPU is in a state that latch INIT signals.
>=20
> For further information, refer to patches commit messages.
>=20
> Regards,
> -Liran
>=20

Queued, thanks.

Paolo

