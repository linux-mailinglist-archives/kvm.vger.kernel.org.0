Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700233E4777
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 16:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbhHIOX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 10:23:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20712 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234995AbhHIOX4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 10:23:56 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179ELlZU125900;
        Mon, 9 Aug 2021 10:23:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ETvsuerive3vOMJVANgx3kPKEw8PHVLbEpE5ztWC/Bg=;
 b=ViQKK6Q+Df9vQohYn6WWcKqQHuIc+UC8O8mgy2LhVtG8h34XmOenvGAH18AwX4VP/dHq
 GAaFBaedLFe3ZQj5F+h4z1i7PrFyqgRQvpNi4R9NW3ojDEM0APBzspikUWRblKeyZydj
 YVEj9s22ZQ0zE28qn0OP9mgSq0brWQRCsmDtcyWF4yxVRfA4liz+U7bOxfHyJqQrAKJi
 Ao2hJkK4/i3XXUd4anPRoAFsJSADwnnI8D3sKl/K9JsxhoU56SwmeSSFa5E90LkO+p+6
 EaQ8riJm4cjgAbUGjpPuPU7mR7IxAbe/pWoA2OIpMkpLfoz7v09FlZ5/rK5J3NYelhbZ kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aax6c4spp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 10:23:36 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 179ELqRs126409;
        Mon, 9 Aug 2021 10:23:35 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aax6c4snr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 10:23:35 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 179EIWkP021438;
        Mon, 9 Aug 2021 14:23:33 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3a9ht8knuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 14:23:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 179ENTwN52625874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 14:23:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70A83AE053;
        Mon,  9 Aug 2021 14:23:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27044AE057;
        Mon,  9 Aug 2021 14:23:29 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.151.189])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 14:23:29 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 1/4] s390x: lib: Add SCLP toplogy nested
 level
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        david@redhat.com
References: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
 <1628498934-20735-2-git-send-email-pmorel@linux.ibm.com>
 <20210809115345.3f0eb1c4@p-imbrenda>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <31fe25db-6df8-90dc-81f4-d37ad17add5e@linux.ibm.com>
Date:   Mon, 9 Aug 2021 16:23:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809115345.3f0eb1c4@p-imbrenda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PvNf45CegAiV9edjiBzBdMwBkr5Gmwpu
X-Proofpoint-ORIG-GUID: dYLbuyPcDCe5-LoskeW3_c2PhKP6VvWb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_04:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 malwarescore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/9/21 11:53 AM, Claudio Imbrenda wrote:
> On Mon,  9 Aug 2021 10:48:51 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> The maximum CPU Topology nested level is available with the SCLP
>> READ_INFO command inside the byte at offset 15 of the ReadInfo
>> structure.
>>
>> Let's return this information to check the number of topology nested
>> information available with the STSI 15.1.x instruction.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
