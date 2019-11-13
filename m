Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A59BAFB0B3
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 13:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbfKMMnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 07:43:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38036 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725908AbfKMMnk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 07:43:40 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADCgsNb017901
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 07:43:39 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w8hk21ab8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 07:43:39 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 13 Nov 2019 12:43:37 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 13 Nov 2019 12:43:36 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADChZQl49610974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 12:43:35 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 035B3A405B;
        Wed, 13 Nov 2019 12:43:35 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2FC9A405F;
        Wed, 13 Nov 2019 12:43:34 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.55])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Nov 2019 12:43:34 +0000 (GMT)
Subject: Re: [PATCH v1 0/4] s390x: Testing the Subchannel I/O
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
 <30d17ea4-1c35-f44a-8736-05725b251c69@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Wed, 13 Nov 2019 13:43:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <30d17ea4-1c35-f44a-8736-05725b251c69@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19111312-0008-0000-0000-0000032EA978
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111312-0009-0000-0000-00004A4DB2E1
Message-Id: <9f3100d9-de50-7e9e-f8a0-dcef2ee923ef@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-13_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911130119
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019-11-13 13:35, Thomas Huth wrote:
>   Hi Pierre!
>
> Meta-comment: Please use "[kvm-unit-tests PATCH ...]" in the subject for
> future kvm-unit-tests patches.


Oh sorry, I didn't notice, thanks.

Will take care for the next series.


>
> On 13/11/2019 13.23, Pierre Morel wrote:
> [...]
>> The simple test tests the I/O reading by the SUB Channel. It needs QEMU to
>> be patched to have the pong device defined.
> Are you going to send QEMU patches for this? I assume that's a
> prerequisite for this patch series?
>
>   Thomas
>
Yes I will.

Regards,

Pierre


-- 
Pierre Morel
IBM Lab Boeblingen

