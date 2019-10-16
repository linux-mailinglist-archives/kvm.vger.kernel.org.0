Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBDAD8908
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 09:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfJPHKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 03:10:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44553 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726402AbfJPHKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 03:10:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571209812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=48tYkDJe0SqGLusONClw8lIZHFqflqFfRXBr2ATDPpg=;
        b=NW4zMlUXY5AClFMVWh8ALxMVIzBvaQDqxmfW6pl9YX7zuBdxgBYhlB98H7spFcif+ayQzJ
        TjHWyVsdz1NXA4vCFrOIJJ0jwxp6QdmP3aq9y73D0YDMFwmBoiK/pDxfqpfPGUVOTlOqBN
        bLzcy7v4CBOqGr5o7rLe1lvevivMGJA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-q8UAbrpkO9WBsYRT-XsGiA-1; Wed, 16 Oct 2019 03:10:10 -0400
Received: by mail-wr1-f71.google.com with SMTP id a15so2226678wrr.0
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 00:10:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8b7UpnoPmb5i1nQSpxNz3HRMIYoZAJY2z85wR9Og0Oo=;
        b=er1EP0PedkimU9U/xyihH62PaTnuaOHy//dD5Yl2WrikYF6o42OheN+SkD7OEj+pTV
         jQpjp9wESvLTQHTa2PS7TuUnBkzOQvrbSPB4ucPvGzz6ho8P27K7iUGk9bnXDlJL2k3t
         w6grPpCb9RVUvCgTDcIMEwe16bZXFPpzvfBHE1rpl7MZhqd3wHgU5GR/zCjLqCcc1+PG
         /8XV7Tf8CQoEI/PKyqG9tfc64Ld6X+Yg8iNgAmIYDZMAck1YV6puEvHW1ZxiBZUji350
         J3Y5WGVr2PClHWouG9BnMmOIIbpRAOHtSs09EBhWzuLhYXgVP115WB8MBh7DKRzY/xgh
         /rYg==
X-Gm-Message-State: APjAAAV8ITB/s5roW8qs1wOnQZ2DXAEIBWGy1uMK98/C6oM3JtFgnM/J
        0KaCKbnOts0Z1zJIUy+AvQNqmBnmu+Hu/HCJIlD8d/0AwzGEsIITTn09vAIjrCq87iJ9lRX14iy
        2HUcly+14HwGx
X-Received: by 2002:adf:cc8e:: with SMTP id p14mr1342966wrj.301.1571209809457;
        Wed, 16 Oct 2019 00:10:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzVEQNXaAuAJVOUPKU0UPAGNhg1SfcLUKvaqKnrK8g/JFc1UdJaCdRin1J2hoFdoWeTpE0hnA==
X-Received: by 2002:adf:cc8e:: with SMTP id p14mr1342946wrj.301.1571209809203;
        Wed, 16 Oct 2019 00:10:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id e18sm33448011wrv.63.2019.10.16.00.10.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 00:10:08 -0700 (PDT)
Subject: Re: [PATCH v5 2/6] ptp: Reorganize ptp_kvm modules to make it
 arch-independent.
To:     Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        nd@arm.com
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-3-jianyong.wu@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e0260f51-ad29-02ba-a46f-ebaa68f7a9ea@redhat.com>
Date:   Wed, 16 Oct 2019 09:10:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015104822.13890-3-jianyong.wu@arm.com>
Content-Language: en-US
X-MC-Unique: q8UAbrpkO9WBsYRT-XsGiA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/19 12:48, Jianyong Wu wrote:
> +=09ret =3D kvm_arch_ptp_init();
> +=09if (!ret)
> +=09=09return -EOPNOTSUPP;

This should be "if (ret)".

Paolo

