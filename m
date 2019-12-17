Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB75122727
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 09:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfLQI4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 03:56:22 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26951 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725893AbfLQI4V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Dec 2019 03:56:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576572979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=Nmdze11AL16+HLGGZDjTrGIbNj6DzVn9f7A6ACZiEI0=;
        b=LGh7O+/9kDUiTiKM39WGhuV8R01mX5LHHX7LveKkKvABjm7QI1NpkRWg8oXwcLAE+hBGT3
        bufoxhdgslGPaXok3U6WgkELE0bhWDo3l07Tzec5qVK+bzRi7P24LarhIil80YaxkrMH/M
        A/yHDmPP7zZfZ5EDKtA40o9fNAXZqnY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-N3kHs_50NUaLZeERtOe-OQ-1; Tue, 17 Dec 2019 03:56:15 -0500
X-MC-Unique: N3kHs_50NUaLZeERtOe-OQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E87C9593AE;
        Tue, 17 Dec 2019 08:56:12 +0000 (UTC)
Received: from [10.40.204.182] (ovpn-204-182.brq.redhat.com [10.40.204.182])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B690C19C4F;
        Tue, 17 Dec 2019 08:55:52 +0000 (UTC)
Subject: Re: [PATCH v15 4/7] mm: Introduce Reported pages
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, konrad.wilk@oracle.com, david@redhat.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
 <20191205162238.19548.68238.stgit@localhost.localdomain>
 <0bb29ec2-9dcb-653c-dda5-0825aea7d4b0@redhat.com>
 <537e970f062e0c7f89723f63fc1f3ec6e53614a5.camel@linux.intel.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <06ca452e-90b3-c1b5-f2c0-e8da2444bcfe@redhat.com>
Date:   Tue, 17 Dec 2019 03:55:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <537e970f062e0c7f89723f63fc1f3ec6e53614a5.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/16/19 11:28 AM, Alexander Duyck wrote:
> On Mon, 2019-12-16 at 05:17 -0500, Nitesh Narayan Lal wrote:
>> On 12/5/19 11:22 AM, Alexander Duyck wrote:
>>> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>>>
>>> In order to pave the way for free page reporting in virtualized
>>> environments we will need a way to get pages out of the free lists an=
d
>>> identify those pages after they have been returned. To accomplish thi=
s,
>>> this patch adds the concept of a Reported Buddy, which is essentially=

>>> meant to just be the Uptodate flag used in conjunction with the Buddy=

>>> page type.
>> [...]
>>
>>> +enum {
>>> +	PAGE_REPORTING_IDLE =3D 0,
>>> +	PAGE_REPORTING_REQUESTED,
>>> +	PAGE_REPORTING_ACTIVE
>>> +};
>>> +
>>> +/* request page reporting */
>>> +static void
>>> +__page_reporting_request(struct page_reporting_dev_info *prdev)
>>> +{
>>> +	unsigned int state;
>>> +
>>> +	/* Check to see if we are in desired state */
>>> +	state =3D atomic_read(&prdev->state);
>>> +	if (state =3D=3D PAGE_REPORTING_REQUESTED)
>>> +		return;
>>> +
>>> +	/*
>>> +	 *  If reporting is already active there is nothing we need to do.
>>> +	 *  Test against 0 as that represents PAGE_REPORTING_IDLE.
>>> +	 */
>>> +	state =3D atomic_xchg(&prdev->state, PAGE_REPORTING_REQUESTED);
>>> +	if (state !=3D PAGE_REPORTING_IDLE)
>>> +		return;
>>> +
>>> +	/*
>>> +	 * Delay the start of work to allow a sizable queue to build. For
>>> +	 * now we are limiting this to running no more than once every
>>> +	 * couple of seconds.
>>> +	 */
>>> +	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
>>> +}
>>> +
>> I think you recently switched to using an atomic variable for maintain=
ing page
>> reporting status as I was doing in v12.
>> Which is good, as we will not have a disagreement on it now.
> There is still some differences between our approaches if I am not
> mistaken. Specifically I have code in place so that any requests to rep=
ort
> while we are actively working on reporting will trigger another pass be=
ing
> scheduled after we completed. I still believe you were lacking any logi=
c
> like that as I recall.
>

Yes, I was specifically referring to the atomic state variable.
Though I am wondering if having an atomic variable to track page reportin=
g state
is better than having a page reporting specific unsigned long flag, which=
 we can
manipulate via __set_bit() and __clear_bit().

>> On a side note, apologies for not getting involved actively in the
>> discussions/reviews as I am on PTO.
> No problem. I've been mostly looking for input from the core MM
> maintainers anyway as we sorted most of the virtualization pieces some
> time ago.
>
--=20
Thanks
Nitesh

