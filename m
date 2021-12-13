Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085024730BF
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 16:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240100AbhLMPpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 10:45:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234484AbhLMPpK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 10:45:10 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BDEvQOV017736;
        Mon, 13 Dec 2021 15:45:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=k/TuME2AJGqJsBHTZ2Rb+3YeCtineC0vq6GNn0aKE8Y=;
 b=TpkVnzz12XYRPqWnvJXYzU805DMGf1Ygk2HCGAVklWhdc5du6+QH0OdGq2GZlE05aB2n
 MIZRNvn2YLZB5szjvI0KGvGhztK1D0auab85KYR5ni8GVxKotvm2s2s7HfSxyJxZTP71
 0j9ktduE6x+eml5jobhIVa3moTmrq+uRFxgilTR/fla9/7xzvTwqiMrbSPHCkQHPNmhf
 q+xV8RzKnGjg8w2UUwccWIfaamjjS4b721ctiGyYdI83XEAcKOF52SJbQrposqlfo8NY
 Q0JmLmngRL/s5uOH7kMkqYiGZP2kGV43Uoyz2I6Yg99TkU3+kMuWha2acFm0mIX8jQlV kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cx8d4h6q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 15:45:10 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BDEwnRw023469;
        Mon, 13 Dec 2021 15:45:09 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cx8d4h6p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 15:45:09 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BDFiWkW001673;
        Mon, 13 Dec 2021 15:45:07 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3cvkma6fet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 15:45:07 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BDFj3rp44761536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 15:45:03 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D060511C058;
        Mon, 13 Dec 2021 15:45:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B14B11C05E;
        Mon, 13 Dec 2021 15:45:03 +0000 (GMT)
Received: from [9.171.24.181] (unknown [9.171.24.181])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 13 Dec 2021 15:45:03 +0000 (GMT)
Message-ID: <1b2903fa-7b83-418d-8fa6-9bdf9ad19640@linux.ibm.com>
Date:   Mon, 13 Dec 2021 16:46:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 1/1] s390x: KVM: accept STSI for CPU topology
 information
Content-Language: en-US
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, gor@linux.ibm.com
References: <20211122131443.66632-1-pmorel@linux.ibm.com>
 <20211122131443.66632-2-pmorel@linux.ibm.com>
 <20211209133616.650491fd@p-imbrenda> <YbImqX/NEus71tZ1@osiris>
 <fbc46b35-10af-2c7e-6e47-e4987070ad83@linux.ibm.com>
 <YbdlDFLjZzpC6RRd@osiris>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <YbdlDFLjZzpC6RRd@osiris>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4D2Z7C5qDideuvog92lsq0xClxYEDLjc
X-Proofpoint-ORIG-GUID: OW728l3AKLNzJEcC8le5Ufmenxx2dXzv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-13_07,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=904
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1015 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112130099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/13/21 16:21, Heiko Carstens wrote:
> On Mon, Dec 13, 2021 at 03:26:58PM +0100, Pierre Morel wrote:
>>> Why is this assumption necessary? The statement that Linux runs only
>>> with horizontal polarization is not true.
>>>
>>
>> Right, I will rephrase this as:
>>
>> "Polarization change is not taken into account, QEMU intercepts queries for
>> polarization change (PTF) and only provides horizontal polarization
>> indication to Guest's Linux."
>>
>> @Heiko, I did not find any usage of the polarization in the kernel other
>> than an indication in the sysfs. Is there currently other use of the
>> polarization that I did not see?
> 
> You can change polarization by writing to /sys/devices/system/cpu/dispatching.
> 
> Or alternativel use the chcpu tool to change polarization. There is
> however no real support for vertical polarization implemented in the
> kernel. Therefore changing to vertical polarization is _not_
> recommended, since it will most likely have negative performance
> impacts on your Linux system.
> However the interface is still there for experimental purposes.
> 

Thanks, so I guess that not reflecting polarization changes to the guest 
topology will be OK for the moment.
Of course, I will change the wrong comment.

-- 
Pierre Morel
IBM Lab Boeblingen
