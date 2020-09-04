Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFCC25D38C
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 10:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729819AbgIDI0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 04:26:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47742 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726655AbgIDI0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 04:26:01 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-_6JwrfygMgCh5W65Mchr2w-1; Fri, 04 Sep 2020 04:25:59 -0400
X-MC-Unique: _6JwrfygMgCh5W65Mchr2w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AECCB80EF9C;
        Fri,  4 Sep 2020 08:25:58 +0000 (UTC)
Received: from [10.36.112.51] (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CEB25C22D;
        Fri,  4 Sep 2020 08:25:54 +0000 (UTC)
Subject: Re: [PATCH v4 00/10] vfio/fsl-mc: VFIO support for FSL-MC device
To:     Diana Craciun OSS <diana.craciun@oss.nxp.com>,
        alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <ae46be70-82d3-6137-6169-beb4bf8ae707@redhat.com>
 <084feb8a-3f9b-efc1-e4f8-eb9a3e60b756@oss.nxp.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <84a44bc8-bd7a-c81a-e7cc-35f0a8d3896a@redhat.com>
Date:   Fri, 4 Sep 2020 10:25:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <084feb8a-3f9b-efc1-e4f8-eb9a3e60b756@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Diana,

On 9/4/20 10:03 AM, Diana Craciun OSS wrote:
> Hi Eric,
> 
> On 9/3/2020 4:40 PM, Auger Eric wrote:
>>> The patches are dependent on some changes in the mc-bus (bus/fsl-mc)
>>> driver. The changes were needed in order to re-use code and to export
>>> some more functions that are needed by the VFIO driver. Currenlty the
>>> mc-bus patches are under review:
>>> https://www.spinics.net/lists/kernel/msg3639226.html 
>> Could you share a branch with both series? This would help the review.
>> Thanks Eric 
> 
> I have pushed both the series here:
> https://source.codeaurora.org/external/qoriq/qoriq-components/linux-extras/log/?h=dpaa2_direct_assignment
> 
> 
> Regards,
> 
> Diana
> 
> PS: I apologize if you received the message twice, I have sent it by
> mistake as html first.
> 
No Problem. Thank you for the branch. I have completed a first review
pass. Hope this helps.

Thanks

Eric

