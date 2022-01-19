Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B734493FA6
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 19:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356646AbiASSJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 13:09:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17800 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234280AbiASSJL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 13:09:11 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JHk2hk007683;
        Wed, 19 Jan 2022 18:09:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/hecvCcFv9f4rRNxsBRnzOy1P/PXkMP4Wr1ktEF7qds=;
 b=Cj+sY4u568Yvs8uPB6mbqkAxA+ucprzlKk6JSs+CIHq8/Xm0aF8rDlvyV0At4J13B670
 dwkPtpOyBSQwdyE1tEuLkKnxno02Donefxi5VBX8UcJppAbbHmraXqvY+QyZKgAKdbYQ
 Lm7m5MmXT3AxvwCPKUE5FTOk+BlLWIFl5yHStvo+GWQkOtYN3NN4ZBkJqy25pYQIcSRm
 abiJsCSBL1sniniSY5HEt0AwSRfXqe96tT24BYfPw6Jo0XKukaShH62NEJNMJ5yHsD/U
 1puFy44CSUdn+r521h8pXbec57BRvo6ZHJezg/QASZJ4ix/k4x7buk6YuUuiq14nzh/o aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dpmeg54wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 18:09:11 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20JI6Osk023177;
        Wed, 19 Jan 2022 18:09:11 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dpmeg54vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 18:09:10 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20JHvYts014050;
        Wed, 19 Jan 2022 18:09:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3dknhjfgx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 18:09:08 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20JI94ON42336724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 18:09:04 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5D4EA405B;
        Wed, 19 Jan 2022 18:09:04 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBE11A4051;
        Wed, 19 Jan 2022 18:09:03 +0000 (GMT)
Received: from [9.171.7.240] (unknown [9.171.7.240])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jan 2022 18:09:03 +0000 (GMT)
Message-ID: <5c84960c-1075-02e1-b342-6e0c1abaa46e@linux.ibm.com>
Date:   Wed, 19 Jan 2022 19:10:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 00/30] KVM: s390: enable zPCI for interpretive
 execution
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eWFJu3JbOxmYmBRyNrrx4rrTYXzVtMQi
X-Proofpoint-ORIG-GUID: dAommOlakDiawkOfe3Z4S962ETUGpYXp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-19_10,2022-01-19_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 suspectscore=0 mlxlogscore=924 clxscore=1015 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> Enable interpretive execution of zPCI instructions + adapter interruption
> forwarding for s390x KVM vfio-pci.  This is done by introducing a series
> of new vfio-pci feature ioctls that are unique vfio-pci-zdev (s390x) and
> are used to negotiate the various aspects of zPCI interpretation setup.
> By allowing intepretation of zPCI instructions and firmware delivery of
> interrupts to guests, we can significantly reduce the frequency of guest
> SIE exits for zPCI.  We then see additional gains by handling a hot-path
> instruction that can still intercept to the hypervisor (RPCIT) directly
> in kvm.
> 
>  From the perspective of guest configuration, you passthrough zPCI devices
> in the same manner as before, with intepretation support being used by
> default if available in kernel+qemu.
> 
> Will reply with a link to the associated QEMU series.

I did the comment in a patch but I think that centralizing it here is 
clearer: I think having a documentation in Documentation/S390 like we 
have already for VFIO AP and VFIO CCW would be a good thing.

-- 
Pierre Morel
IBM Lab Boeblingen
