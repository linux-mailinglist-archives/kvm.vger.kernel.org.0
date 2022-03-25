Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF2E4E6EDC
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 08:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345329AbiCYHa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 03:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237022AbiCYHa4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 03:30:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC74BF014;
        Fri, 25 Mar 2022 00:29:19 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22P63hod027680;
        Fri, 25 Mar 2022 07:29:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZlTk6CiKeOYlqvqKlH67WzGRhtwKqnUYjADP7/iJkFM=;
 b=AwG868l1hndUz2fhcqSkUO+P6z9iy6SCnUemUWfcf4/w7a0pVdIEMKnT8tJmvkE+GAL3
 XCN86sYF7MyQ1UgZ8NRvR8vqi9XXMdEKKqT1ce8naAoYNYAkF1UikY7qRqX7Gdd9svCX
 fHHkAdT2xPWvRPCch8vGaFGX+nUJE02Q3yETXtm7j9ADFlywDNKBc2PSsTQ3dv2LEiHL
 KomWuBqh6j7hOmTkW6PlY+fh15qrz3n1KrVXTGj3jxxtgfE1+iOAPIlR10F/QiAOK1X7
 5JORfn82/c89EF0raAw3yg5UNqUpNnhMq4eehdHCHZMPCfXxgSduVgtLa881SERG0U5G sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f0qkmx8ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 07:29:18 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22P7ITYp009757;
        Fri, 25 Mar 2022 07:29:18 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f0qkmx8bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 07:29:18 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22P7TG9H019511;
        Fri, 25 Mar 2022 07:29:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3ew6t94m2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 07:29:15 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22P7TCRs44040584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 07:29:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7602152050;
        Fri, 25 Mar 2022 07:29:12 +0000 (GMT)
Received: from [9.145.191.115] (unknown [9.145.191.115])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 254A95204F;
        Fri, 25 Mar 2022 07:29:12 +0000 (GMT)
Message-ID: <a2870c6b-6b2a-0a81-435e-ec0f472697c6@linux.ibm.com>
Date:   Fri, 25 Mar 2022 08:29:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Heiko Carstens <hca@linux.ibm.com>, Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        farman@linux.ibm.com
References: <20220323170325.220848-1-nrb@linux.ibm.com>
 <20220323170325.220848-4-nrb@linux.ibm.com> <YjytK7iW7ucw/Gwj@osiris>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/9] s390x: gs: move to new header file
In-Reply-To: <YjytK7iW7ucw/Gwj@osiris>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PAJxajxAh3seO4tdgaODitLAVJ0Xuy9y
X-Proofpoint-GUID: ksqp_VQnn6W1EcrL-YAnpuuyA9TKKC5U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-25_02,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 suspectscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxlogscore=983 phishscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203250038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/24/22 18:40, Heiko Carstens wrote:
> On Wed, Mar 23, 2022 at 06:03:19PM +0100, Nico Boehr wrote:
> ...
>> +static inline unsigned long load_guarded(unsigned long *p)
>> +{
>> +	unsigned long v;
>> +
>> +	asm(".insn rxy,0xe3000000004c, %0,%1"
>> +	    : "=d" (v)
>> +	    : "m" (*p)
>> +	    : "r14", "memory");
>> +	return v;
>> +}
> 
> It was like that before, but why is r14 within the clobber list?
> That doesn't make sense.

r14 is changed in the gs handler of the gs test which is executed if the 
"guarded" part of the load takes place.
