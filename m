Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3583CFDB4A
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfKOK0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:26:52 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48418 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726983AbfKOK0w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 05:26:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573813611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=2uI7uPLuRnONP7GjNCVwBtzrmnqY0NlUVSvuNw0sBt4=;
        b=DcuWp7jsILJHZi4FwUHbcii2gyp7kIBrdFZKJwNRi7ABCpdTbHe/qcWFeqFD9Ul1CTEBaQ
        s9JWlOSY8ONT1gwoL0EBSkQNa8VfHGM28gfLaZrYsXCe3pqBmH33b3lKeObyUNXeaWuG5I
        xUaRGZXPXCDmIQJ/jVHiJrf1fQa/p+Q=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-Jbs_hChCONeo9SFY2feYqw-1; Fri, 15 Nov 2019 05:26:50 -0500
Received: by mail-wr1-f72.google.com with SMTP id k15so7426322wrp.22
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 02:26:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=acft+e5GVaOm9gL1F/GvBW+HVqPDv3uXhEV7pWu1UxM=;
        b=LWLi+QIUU4D+fYI3olE5lRzkyqxWREw9N42ju8w/EFZUv9bytc/kuukc0aj0tPlQb1
         /YotVLqUfjTg9nslasoqiwAWORUrg5BthHVvWLFZhVTsEZVG6RaqgAJmltMXILNTuhyr
         kjDwxY5Z+eW7kUBzTc1puiNEK3s9W5r55kcA6KFfzyRThzpkvZW8hladMbNR3YXpYJSj
         DlicoKoapC1qsBQMs2rchNaHIprCKqizeRs0KPpe+EDjaDbt3GBSvcqab0BfsAbKUYAs
         kYzxM6x+GvjVHZ0hJBVyn1o358Y6p3vzNsvjerk3mSKPMEAzVAisZJ2WeN5hoIvb2/wa
         nmzg==
X-Gm-Message-State: APjAAAXaC7foqDp3ESXDeseMf466pg2rf0jaMPiK4XzeMB3uYzWrb+bs
        U1ArJZCTAaS+q9g0cT0JzwgzTMpOuTgoWt2Gfptop3SSDrniRh3xk7Ox+O/bzPidsKUKpug+va7
        gnBWIobjBHOiN
X-Received: by 2002:a1c:a791:: with SMTP id q139mr13326249wme.155.1573813609420;
        Fri, 15 Nov 2019 02:26:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqwExwQL3OQvA5LaPYzHOAjOqe7Mx8KKnsDSwyYuInWa10ioYJUc6tY/7eWewSeXBq25GRzWvQ==
X-Received: by 2002:a1c:a791:: with SMTP id q139mr13326229wme.155.1573813609152;
        Fri, 15 Nov 2019 02:26:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id u2sm12362382wrg.52.2019.11.15.02.26.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 02:26:48 -0800 (PST)
Subject: Re: [Patch v2 2/2] KVM: x86: deliver KVM IOAPIC scan request to
 target vCPUs
To:     Nitesh Narayan Lal <nitesh@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        rkrcmar@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
References: <1573131223-5685-1-git-send-email-nitesh@redhat.com>
 <1573131223-5685-3-git-send-email-nitesh@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <62be5025-374b-6837-77dd-05ab2148f295@redhat.com>
Date:   Fri, 15 Nov 2019 11:26:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1573131223-5685-3-git-send-email-nitesh@redhat.com>
Content-Language: en-US
X-MC-Unique: Jbs_hChCONeo9SFY2feYqw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/11/19 13:53, Nitesh Narayan Lal wrote:
> In IOAPIC fixed delivery mode instead of flushing the scan
> requests to all vCPUs, we should only send the requests to
> vCPUs specified within the destination field.
>=20
> This patch introduces kvm_get_dest_vcpus_mask() API which
> retrieves an array of target vCPUs by using
> kvm_apic_map_get_dest_lapic() and then based on the
> vcpus_idx, it sets the bit in a bitmap. However, if the above
> fails kvm_get_dest_vcpus_mask() finds the target vCPUs by
> traversing all available vCPUs. Followed by setting the
> bits in the bitmap.

Queued, thanks.  I just took the liberty of renaming the function to
kvm_bitmap_or_dest_vcpus.

Paolo

