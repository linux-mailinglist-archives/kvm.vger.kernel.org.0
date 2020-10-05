Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6185283729
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 16:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgJEOB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 10:01:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26596 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725954AbgJEOB1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 10:01:27 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 095CWSvp115782
        for <kvm@vger.kernel.org>; Mon, 5 Oct 2020 08:57:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Xe3vQHFI5gYn9yTDoTEwUPYqvITKXUFLny0WIIKAW8U=;
 b=DXIwP/JBvHoMisp3nteXcfkr+It2TZJtpR+3K9RvXzD1FhktmCikhGZmgCbhA5OQwPVB
 ZS1PonPMw7muqS1mbs+8n7KTLBVCATVjTeVyZ11l6mAT8X4ovFXKjROp1VPC42XKk/xb
 DU7wv1hdEzXTiGleNTEsjjlGaZy3mMhpCdJVYippgK9cWQtRouFDedRK4MkluhXr0Ufr
 kFNZ5XfbrhBlUh3nJ/Z9/O4dXqUclptd6LhXL6F18cGRFghvasLjRAPDMK7ufKSN2LFm
 T9wrK+lOZiuwrS9MF3yR7j4lHP+7MAkfzffPtXqGWjjZHysHYS1uMdq85jmfYtD7nEx+ 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3403c8s2f9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 05 Oct 2020 08:57:22 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 095CvLGQ034656
        for <kvm@vger.kernel.org>; Mon, 5 Oct 2020 08:57:21 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3403c8s2eh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 08:57:21 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 095Crv3C017934;
        Mon, 5 Oct 2020 12:57:19 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 33xgx89490-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 12:57:19 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 095CvGQq21954940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Oct 2020 12:57:16 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55638A4040;
        Mon,  5 Oct 2020 12:57:16 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E966BA4051;
        Mon,  5 Oct 2020 12:57:15 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.6.235])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  5 Oct 2020 12:57:15 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 0/7] Rewrite the allocators
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
 <aec4a269-efba-83c0-cbbb-c78b132b1fa9@linux.ibm.com>
 <20201005143503.669922f5@ibm-vm>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <ceff99e4-e79c-2d92-fb02-f5a020da3ff1@linux.ibm.com>
Date:   Mon, 5 Oct 2020 14:57:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201005143503.669922f5@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_06:2020-10-02,2020-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 clxscore=1015 mlxscore=0 impostorscore=0 suspectscore=0 mlxlogscore=439
 phishscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-10-05 14:35, Claudio Imbrenda wrote:
> On Mon, 5 Oct 2020 13:54:42 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
> [...]
> 
>> While doing a page allocator, the topology is not the only
>> characteristic we may need to specify.
>> Specific page characteristics like rights, access flags, cache
>> behavior may be useful when testing I/O for some architectures.
>> This obviously will need some connection to the MMU handling.
>>
>> Wouldn't it be interesting to use a bitmap flag as argument to
>> page_alloc() to define separate regions, even if the connection with
>> the MMU is done in a future series?
> 
> the physical allocator is only concerned with the physical pages. if
> you need special MMU flags to be set, then you should enable the MMU
> and fiddle with the flags and settings yourself.
> 

AFAIU the page_allocator() works on virtual addresses if the MMU has 
been initialized.

Considering that more and more tests will enable the MMU by default, 
eventually with a simple logical mapping, it seems to me that having the 
possibility to give the page allocator more information about the page 
access configuration could be interesting.

I find that using two different interfaces, both related to memory 
handling, to have a proper memory configuration for an I/O page may be 
complicated without some way to link page allocator and MMU tables together.


-- 
Pierre Morel
IBM Lab Boeblingen
