Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC934D1B5
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 17:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731940AbfFTPJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 11:09:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51114 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726675AbfFTPJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 11:09:44 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 44F243082140;
        Thu, 20 Jun 2019 15:09:44 +0000 (UTC)
Received: from localhost (unknown [10.43.2.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3279419C5B;
        Thu, 20 Jun 2019 15:09:39 +0000 (UTC)
Date:   Thu, 20 Jun 2019 17:09:34 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     gengdongjiu <gengdongjiu@huawei.com>
Cc:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
Subject: Re: [Qemu-devel] [PATCH v17 02/10] ACPI: add some GHES structures
 and macros definition
Message-ID: <20190620170934.39eae310@redhat.com>
In-Reply-To: <f4f94ecb-200c-3e18-1a09-5fb6bc761834@huawei.com>
References: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
        <1557832703-42620-3-git-send-email-gengdongjiu@huawei.com>
        <20190620141052.370788fb@redhat.com>
        <f4f94ecb-200c-3e18-1a09-5fb6bc761834@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 20 Jun 2019 15:09:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Jun 2019 22:04:01 +0800
gengdongjiu <gengdongjiu@huawei.com> wrote:

> Hi Igor,
>    Thanks for your review.
> 
> On 2019/6/20 20:10, Igor Mammedov wrote:
> >> + */
> >> +struct AcpiGenericErrorStatus {
> >> +    /* It is a bitmask composed of ACPI_GEBS_xxx macros */
> >> +    uint32_t block_status;
> >> +    uint32_t raw_data_offset;
> >> +    uint32_t raw_data_length;
> >> +    uint32_t data_length;
> >> +    uint32_t error_severity;
> >> +} QEMU_PACKED;
> >> +typedef struct AcpiGenericErrorStatus AcpiGenericErrorStatus;  
> > there shouldn't be packed structures,
> > is it a leftover from previous version?  
> 
> I remember some people suggest to add QEMU_PACKED before, anyway I will remove it in my next version patch.

Question is why it's  there and where it is used?

BTW:
series doesn't apply to master anymore.
Do you have a repo somewhere available for testing?

> 
> >   
> >> +
> >> +/*
> >> + * Masks for block_status flags above
> >> + */
> >> +#define ACPI_GEBS_UNCORRECTABLE         1
> >> +
> >> +/*  
> 

