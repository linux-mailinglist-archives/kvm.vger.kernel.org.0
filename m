Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00B82054F5
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 16:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732821AbgFWOiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 10:38:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18738 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732738AbgFWOiW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 10:38:22 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NEX67i033482;
        Tue, 23 Jun 2020 10:38:21 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31ukkng7r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 10:38:20 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05NEX9h0033877;
        Tue, 23 Jun 2020 10:38:19 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31ukkng7qd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 10:38:19 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05NEaJvv027641;
        Tue, 23 Jun 2020 14:38:19 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 31uk2mr8pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 14:38:19 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05NEcFhO26280290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 14:38:15 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A50566E050;
        Tue, 23 Jun 2020 14:38:15 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B38DD6E054;
        Tue, 23 Jun 2020 14:38:14 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.182.30])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Tue, 23 Jun 2020 14:38:14 +0000 (GMT)
Subject: Re: [PATCH v9 0/2] Use DIAG318 to set Control Program Name & Version
 Codes
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
References: <20200622154636.5499-1-walling@linux.ibm.com>
 <cfe77de0-e1d8-5779-541f-286cf3002459@de.ibm.com>
From:   Collin Walling <walling@linux.ibm.com>
Message-ID: <704fd712-1883-9aad-bb60-4412cb8a9573@linux.ibm.com>
Date:   Tue, 23 Jun 2020 10:38:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <cfe77de0-e1d8-5779-541f-286cf3002459@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_07:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230110
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/23/20 3:13 AM, Christian Borntraeger wrote:
> 
> 
> On 22.06.20 17:46, Collin Walling wrote:
>> Changelog:
>>
>>     v9
>>
>>     • No longer unshadowing CPNC in VSIE
>>
> applied. 
> 

Thanks!

-- 
Regards,
Collin

Stay safe and stay healthy
