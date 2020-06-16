Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6151C1FBA81
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 18:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732123AbgFPQLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 12:11:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18882 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730984AbgFPQLp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 12:11:45 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05GG3kFx018055;
        Tue, 16 Jun 2020 12:11:44 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31pgbxtp2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 12:11:43 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05GG9k3e033855;
        Tue, 16 Jun 2020 12:11:43 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31pgbxtp24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 12:11:43 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05GFxif6008442;
        Tue, 16 Jun 2020 16:11:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 31mpe7wmcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 16:11:40 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05GGALTY9109780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 16:10:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 893564C052;
        Tue, 16 Jun 2020 16:11:38 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38B654C04E;
        Tue, 16 Jun 2020 16:11:38 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.26.88])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Jun 2020 16:11:38 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v9 01/12] s390x: Use PSW bits definitions
 in cstart
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-2-git-send-email-pmorel@linux.ibm.com>
 <f160d328-694a-4476-4863-c49a1d0e5349@redhat.com>
 <eebf1927-f1b2-cca0-529a-9a97c761345d@linux.ibm.com>
Message-ID: <fc27e211-2d9c-63f1-4f10-ca3d744a3ea7@linux.ibm.com>
Date:   Tue, 16 Jun 2020 18:11:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <eebf1927-f1b2-cca0-529a-9a97c761345d@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-16_07:2020-06-16,2020-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=711 mlxscore=0 suspectscore=0
 cotscore=-2147483648 impostorscore=0 spamscore=0 phishscore=0
 clxscore=1015 malwarescore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160110
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-16 18:08, Pierre Morel wrote:
> 
> 
> On 2020-06-16 15:13, Thomas Huth wrote:
>> On 15/06/2020 11.31, Pierre Morel wrote:
>>> This patch defines the PSW bits EA/BA used to initialize the PSW masks
>>> for exceptions.
> 

> 
> Should I keep your RB for the arch_def.h ?
> 

Hi, sorry, the changes in arch_def go are not used any more so...

-- 
Pierre Morel
IBM Lab Boeblingen
