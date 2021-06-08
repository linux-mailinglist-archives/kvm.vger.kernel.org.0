Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D0E39FC64
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 18:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbhFHQ0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 12:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233046AbhFHQZ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 12:25:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7779461185;
        Tue,  8 Jun 2021 16:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623169445;
        bh=8v1KyFbM4GJgpLqjlDyuFxRHG8XVuZG7F7r7v4rZAp8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=rWRgDhM3QbuH2tw+aHp7Lq1R8XiozENdQjZSjDgN+dyx1q8FcA+huh6BvmibeP+sh
         4t/K0yaGg6WXD1018WfK+kOge49OCJQKJ94Yj2NI4ZNgy1YzHxaovMJukBfE9kR0IT
         cr0OnWR7b+Ca4HK5wgugnmUjOa9NpOhaXirfsvXbyM6YXWiSh/i/orJg9ZdhrnQmwL
         VbCszQ9tqV3Vtp4v5FJbCpTBbpNWfNmbydX1/+82Zbmc9cN8CtUoCEcPytmaX8kNY3
         0jaFJFMxlKknoN+7AQr9M64IlzDyig7zQnXKhnFxZtjKjpZ7VHxt4X1RQ4OyaJxjMO
         CCg8VP9nopBKg==
Subject: Re: [PATCH 0/7] Do not read from descriptor ring
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, hch@infradead.org,
        ak@linux.intel.com
References: <20210604055350.58753-1-jasowang@redhat.com>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <1c079daa-f73d-cb1a-15ef-d8f57f9813b8@kernel.org>
Date:   Tue, 8 Jun 2021 09:24:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210604055350.58753-1-jasowang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/21 10:53 PM, Jason Wang wrote:
> Hi:
> 
> The virtio driver should not trust the device. This beame more urgent
> for the case of encrtpyed VM or VDUSE[1]. In both cases, technology
> like swiotlb/IOMMU is used to prevent the poking/mangling of memory
> from the device. But this is not sufficient since current virtio
> driver may trust what is stored in the descriptor table (coherent
> mapping) for performing the DMA operations like unmap and bounce so
> the device may choose to utilize the behaviour of swiotlb to perform
> attacks[2].

Based on a quick skim, this looks entirely reasonable to me.

(I'm not a virtio maintainer or expert.  I got my hands very dirty with
virtio once dealing with the DMA mess, but that's about it.)

--Andy
