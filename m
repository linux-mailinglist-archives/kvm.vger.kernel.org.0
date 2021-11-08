Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E00447FF5
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239743AbhKHNC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 08:02:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4272 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238770AbhKHNC2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 08:02:28 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8CC5jF025155
        for <kvm@vger.kernel.org>; Mon, 8 Nov 2021 12:59:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=evql1dvEx0sCdvtnK2X0piIrnWZyemtLzNl7uUM/zys=;
 b=MTp6GZEDE5Vj+PicnykpxWN6gXBd6VOhzHS2RVPHUuJ/KtlzbfXDrd6rGlIA1/Uorj0r
 +P2TLLtRAVfU1g21coRWDav49nR2/NKRj65Y22L9gIm5YOlEOox81LoCVpPAMSAzaOXb
 oRlQAnrZD5G45qKAwtVKF/s0lC8w9kJDg6W7vClTCm4pXOYwPNoEyBGrg8VJSBV0ufkX
 UYHydfNIAwB+ZvsAFefrJHZxlMtAwkXEKxjz0V8P3wqMoXeLkx4PKInfcN8kubfCogRj
 etQEt87fVvfNfGsZUheqZxwjjeAzhwPJqm0b7WZ4/Z8tV0VL6QMPfl3UJbmI2LaeiS70 Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c6qeyh0mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 12:59:44 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A8ClYIS017618
        for <kvm@vger.kernel.org>; Mon, 8 Nov 2021 12:59:44 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c6qeyh0ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:59:43 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8CxVt4018186;
        Mon, 8 Nov 2021 12:59:41 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3c5hb94x8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:59:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8CxcT13015242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Nov 2021 12:59:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50F5842042;
        Mon,  8 Nov 2021 12:59:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7DEF4207D;
        Mon,  8 Nov 2021 12:59:36 +0000 (GMT)
Received: from [9.171.49.228] (unknown [9.171.49.228])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Nov 2021 12:59:36 +0000 (GMT)
Message-ID: <4d85f61a-818c-4f72-6488-9ae2b21ad90a@linux.ibm.com>
Date:   Mon, 8 Nov 2021 14:00:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 6/7] s390x: virtio tests setup
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-7-git-send-email-pmorel@linux.ibm.com>
 <20211103075636.hgxckmxs62bsdrha@gator.home>
 <c977b200-ba2d-d3eb-eae0-75a17d16496d@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <c977b200-ba2d-d3eb-eae0-75a17d16496d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hhiFTlOaP3_S7NOpPIuMBSNUqsnrPE-8
X-Proofpoint-ORIG-GUID: LdhJJVZKY1f6lKp0NICVhVCTh0XBbHqu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_04,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/3/21 09:14, Thomas Huth wrote:
> On 03/11/2021 08.56, Andrew Jones wrote:
>> On Fri, Aug 27, 2021 at 12:17:19PM +0200, Pierre Morel wrote:
>>> +
>>> +#define VIRTIO_ID_PONG         30 /* virtio pong */
>>
>> I take it this is a virtio test device that ping-pong's I/O. It sounds
>> useful for other VIRTIO transports too. Can it be ported? Hmm, I can't
>> find it in QEMU at all?
> 
> I also wonder whether we could do testing with an existing device 
> instead? E.g. do a loopback with a virtio-serial device? Or use two 
> virtio-net devices, connect them to a QEMU hub and send a packet from 
> one device to the other? ... that would be a little bit more complicated 
> here, but would not require a PONG device upstream first, so it could 
> also be used for testing older versions of QEMU...
> 
>   Thomas
> 
> 

Yes having a dedicated device has the drawback that we need it in QEMU.
On the other hand using a specific device, serial or network, wouldn't 
we get trapped with a reduce set of test possibilities?

The idea was to have a dedicated test device, which could be flexible 
and extended to test all VIRTIO features, even the current 
implementation is yet far from it.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
