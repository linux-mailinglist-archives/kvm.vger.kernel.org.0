Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D84529CF4
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 10:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243124AbiEQIyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 04:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240133AbiEQIyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 04:54:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736D1286F4;
        Tue, 17 May 2022 01:54:05 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24H8DOor028628;
        Tue, 17 May 2022 08:54:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IK3WS6B1ntDXuWfHT3QTTcjg0U24TffDhf5X/gqp+Sc=;
 b=ob1tyay55iC1Oy0wYbDiWekbWSUr+SjyvtCWVOpyDnV8VlX50AGPaXHEi5fe0EwqaaE1
 ZTgUuAc4bkWalmAu9uY2IX/RrKq+nkwThUfYM0kTDrlciLNyNN8SUISx21ABp1CuGxeV
 CWkjq1rmI6Mlw0Sd26XXxXYzqTnBIi3DOJ6b9hG2kmxTUOfgicI3NQ8SDit0ohDBkJSj
 6hH33bHfTb1D6j180ZD4R9fQz+6GGMGaS8Hp4S9Z6XK45ythcxCRQkGeLSUvHBVtLgEF
 Rn/EjNfeCTG6lqA1tZp7sKWZOqSu8j2hBcFTtI37tYbHRP3+JlD29+k9O37sUe2jX1ch pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g480fgu8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 08:54:04 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24H8nxXW019252;
        Tue, 17 May 2022 08:54:04 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g480fgu7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 08:54:03 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24H8mGGE006264;
        Tue, 17 May 2022 08:54:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3g23pjbwk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 08:54:02 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24H8rQY924641798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 08:53:26 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D339A4053;
        Tue, 17 May 2022 08:53:58 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41ED8A404D;
        Tue, 17 May 2022 08:53:58 +0000 (GMT)
Received: from [9.152.224.153] (unknown [9.152.224.153])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 08:53:58 +0000 (GMT)
Message-ID: <59e64e65-08f1-1da8-ed00-3103d678894b@linux.ibm.com>
Date:   Tue, 17 May 2022 10:53:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH 4/6] s390x: uv-host: Add access exception
 test
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        kvm390 mailing list 
        <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
References: <20220513095017.16301-1-frankja@linux.ibm.com>
 <20220513095017.16301-5-frankja@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220513095017.16301-5-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aZfefnz_AU00vSn_vshI3xasDLLCh17w
X-Proofpoint-GUID: Emsz-dd6aqiWkknO0odmbhgGsKUEfHpZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_01,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 clxscore=1015 spamscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170051
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/13/22 11:50, Janosch Frank wrote:
> Let's check that we get access exceptions if the UVCB is on an invalid
> page or starts at a valid page and crosses into an invalid one.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
