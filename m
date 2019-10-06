Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8A6CCF3E
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2019 09:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfJFHyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Oct 2019 03:54:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51464 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbfJFHyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Oct 2019 03:54:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x967nKI5081017;
        Sun, 6 Oct 2019 07:52:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=CIGl62hTxZvtRryW3VI5SN1WALWHfBPpjLitA/UZU8s=;
 b=ZYwdbdlEPC4VnRcc0shJRMn2BkpDj/SukcvmVaAsGPgi9EV+2QS3R+qNTXDu3S9JIgwj
 nWq+vvoUIVpm3UVploDg/Ba8EG2I7OGBD2Wzolq8VnrmxrVbQM6ysq/7JK1Emxd7d+B3
 yS6NLBv3qIFVl1Vb75uxHlZ/Cwyfs2kS3RbHpIVbQlSBfp0FTybaFXzwRmD10rYDM1VC
 MQ966CVvsmshx/Wio0BCyeuyhUElH5vZl4aXZ0ZfePOxDMto1a+OSlGECkisWYqkEDm/
 JCc6J+NDFc/J6dyB8TPJUo+eYLkek8FUiiukcSqz/mhE2ryDy6ip/ewe8HuwMmNX0ghD KQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vektr2q0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Oct 2019 07:52:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x967hu5E048615;
        Sun, 6 Oct 2019 07:52:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vf4pfhrqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Oct 2019 07:52:22 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x967qK6f031998;
        Sun, 6 Oct 2019 07:52:20 GMT
Received: from [10.191.5.27] (/10.191.5.27)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Oct 2019 00:52:19 -0700
Subject: Re: [PATCH v4 3/4] xen: Mark "xen_nopvspin" parameter obsolete
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-kernel@vger.kernel.org
Cc:     vkuznets@redhat.com, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        jgross@suse.com, sstabellini@kernel.org, peterz@infradead.org,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <1570111335-12731-1-git-send-email-zhenzhong.duan@oracle.com>
 <1570111335-12731-4-git-send-email-zhenzhong.duan@oracle.com>
 <2c644c4a-f562-3271-ce0b-e60a44d82d89@oracle.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <99d15788-cc14-c8e5-80b1-0dc0777a5993@oracle.com>
Date:   Sun, 6 Oct 2019 15:52:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <2c644c4a-f562-3271-ce0b-e60a44d82d89@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9401 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910060079
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9401 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910060080
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/10/4 22:57, Boris Ostrovsky wrote:
> On 10/3/19 10:02 AM, Zhenzhong Duan wrote:
>> Map "xen_nopvspin" to "nopvspin", fix stale description of "xen_nopvspin"
>> as we use qspinlock now.
>>
>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> Cc: Juergen Gross <jgross@suse.com>
>> Cc: Stefano Stabellini <sstabellini@kernel.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>
> with a small nit
>
>>   void __init xen_init_spinlocks(void)
>>   {
>> +	if (nopvspin)
>> +		xen_pvspin = false;
>>   
>>   	/*  Don't need to use pvqspinlock code if there is only 1 vCPU. */
>>   	if (num_possible_cpus() == 1)
> I'd fold the change into this 'if' statement, I think it will still be
> clear what the comment refers to.

Good suggestion, will do that. Thanks

Zhenzhong

