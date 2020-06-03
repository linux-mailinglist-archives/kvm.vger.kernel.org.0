Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D3E1ED323
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 17:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgFCPQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 11:16:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33445 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726066AbgFCPQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 11:16:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591197375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vpyY9p8AOxwPPLIrLPh3CRXe3/0oCjVevbVbZH4U6HY=;
        b=fV+2d3+KEgelmxVGddt11Gza9F1xLGUbtQ2rtWBrIDlhexXkPBQrfjOCmhHgd6/9IzSh4A
        IUYcpe+gLT/vw1J03FaDbHFRNdSOpGBspBC0h0Bgsz5GzbiiyOLPEe+LZMn7ijHMIuD23U
        mvfW5UKg5Yuc4dWIJm/ynh0Xg/NRPCI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-IwXC8NdXMeSzOtTuJtrDYA-1; Wed, 03 Jun 2020 11:16:09 -0400
X-MC-Unique: IwXC8NdXMeSzOtTuJtrDYA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBCB9107B7C3;
        Wed,  3 Jun 2020 15:16:06 +0000 (UTC)
Received: from [10.3.113.22] (ovpn-113-22.phx2.redhat.com [10.3.113.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E07E160C47;
        Wed,  3 Jun 2020 15:15:55 +0000 (UTC)
Subject: Re: [PATCH v3 00/20] virtio-mem: Paravirtualized memory hot(un)plug
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        teawater <teawaterz@linux.alibaba.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Juan Quintela <quintela@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Markus Armbruster <armbru@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
References: <20200603144914.41645-1-david@redhat.com>
From:   Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
Message-ID: <db32fec4-f758-50d2-185d-b865fe42fd6c@redhat.com>
Date:   Wed, 3 Jun 2020 10:15:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200603144914.41645-1-david@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/20 9:48 AM, David Hildenbrand wrote:
> This is the very basic, initial version of virtio-mem. More info on
> virtio-mem in general can be found in the Linux kernel driver v2 posting
> [1] and in patch #10. The latest Linux driver v4 can be found at [2].
> 
> This series is based on [3]:
>      "[PATCH v1] pc: Support coldplugging of virtio-pmem-pci devices on all
>       buses"
> 

Let's spell that in a form patchew can recognize:

Based-on: <20200525084511.51379-1-david@redhat.com>

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3226
Virtualization:  qemu.org | libvirt.org

