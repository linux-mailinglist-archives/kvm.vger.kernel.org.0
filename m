Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38725447FE0
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbhKHMz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:55:59 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229966AbhKHMz4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 07:55:56 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8AOXAx006252
        for <kvm@vger.kernel.org>; Mon, 8 Nov 2021 12:53:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=zwkQY5hmJP1oAyavl00vftYpdB2CmrsgSyDdHmXN3Bo=;
 b=Bj09sCH8/RRthGqau0bWr1I4rUq+9e5+AAYfiDWiqcJpDi7rH2oHDzD0x+NiEpQw13ZM
 Izce0/+fWDeVy9CDcfhpvdScFVDhS21Oxt/4eM5bGOIAjbgurBxEO1YsRu0jtIEy8QKW
 zQREmVSy3PMxobAApkeXMDyPY2NN8Yh18CMNdLeZk9Va/JkdKvkGVvBXC2c7DL2xHbrz
 8UDsndBeP3T5fpS7jIzELcjYyn6vVJu9mHUn4n7OMAMLrcwpztd4REG0KpPSHiTp+0yy
 j3HyJBtIQZVQASPsO4cb6PT627GV3mDIbx7LrIMjx18eC6TCsiaQEdAjGumx8d63x5xf 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c641shkt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 12:53:12 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A8Cqgbs019111
        for <kvm@vger.kernel.org>; Mon, 8 Nov 2021 12:53:12 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c641shkrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:53:12 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8Cpk2L011835;
        Mon, 8 Nov 2021 12:53:07 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3c5gyj667t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:53:07 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8CkTTY60752210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Nov 2021 12:46:29 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D59342042;
        Mon,  8 Nov 2021 12:53:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AAE84203F;
        Mon,  8 Nov 2021 12:53:02 +0000 (GMT)
Received: from [9.171.49.228] (unknown [9.171.49.228])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Nov 2021 12:53:01 +0000 (GMT)
Message-ID: <f0bff623-5fcf-8fa5-4a49-b28285dfe2d3@linux.ibm.com>
Date:   Mon, 8 Nov 2021 13:53:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 6/7] s390x: virtio tests setup
Content-Language: en-US
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-7-git-send-email-pmorel@linux.ibm.com>
 <20211103075636.hgxckmxs62bsdrha@gator.home>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211103075636.hgxckmxs62bsdrha@gator.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HMZZqqRfzp8vioVG5oVsVNFR6ivvgFXM
X-Proofpoint-ORIG-GUID: oUnIBurhesBokDAe8WoLBN6TX6ot6RbC
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_04,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 bulkscore=0 clxscore=1015 mlxscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=979 priorityscore=1501 adultscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/3/21 08:56, Andrew Jones wrote:
> On Fri, Aug 27, 2021 at 12:17:19PM +0200, Pierre Morel wrote:
>> +
>> +#define VIRTIO_ID_PONG         30 /* virtio pong */
> 
> I take it this is a virtio test device that ping-pong's I/O. It sounds
> useful for other VIRTIO transports too. Can it be ported? Hmm, I can't
> find it in QEMU at all?
> 
> Thanks,
> drew
> 

It could certainly be ported, I will study the question.

I sent a first version of the QEMU part here:

https://marc.info/?l=kvm&m=163006146622427&w=3


Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
