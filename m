Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E196052A480
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 16:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348586AbiEQOOs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 10:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348583AbiEQOOo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 10:14:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E194F9DB;
        Tue, 17 May 2022 07:14:43 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HEDJfC004361;
        Tue, 17 May 2022 14:14:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PWX3sX99ssyRs3zjd5eAb3ijkGoQaW8NV5bfID7TbWk=;
 b=CEkEUjMEPQaZizAeDuMyN5mWJyX/Tc692cM11a5OnyVzmSu3XDIupyt8S6RG2qNYgSt7
 FS110qvPl+FiyY5MkludJ49bLKJ8TCHa657r1MGs8AyRh9EErqdrVV6DJPEM7sNwXBJQ
 KQ3bUxDLyo90Zpj1vYWQ2hKshoX3me1ixVQ2zUGhfWP+DgMhzUL12/zMA7i0p+YHn+3s
 Vg5wRjG3wu2to6iQza6Q3ddTNPJ6TqKf0XmsTz1ByUX5oepmGzzL3wXGoBFLhTZ8dMBn
 IeJsX1if93I2OgmZA6CS0NPg9I8qSUa/MrcMyIIiT4zRvZ0zZV1w7iZvKkVx6xybT9mk Ww== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4d9800rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 14:14:42 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HE8xFR016834;
        Tue, 17 May 2022 14:14:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3g2428ufdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 14:14:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HEEbqP44892606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 14:14:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FDF0A4053;
        Tue, 17 May 2022 14:14:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9A9CA4051;
        Tue, 17 May 2022 14:14:36 +0000 (GMT)
Received: from [9.152.224.153] (unknown [9.152.224.153])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 14:14:36 +0000 (GMT)
Message-ID: <243d2de2-0bfc-a6d9-5b55-03d4269b0725@linux.ibm.com>
Date:   Tue, 17 May 2022 16:14:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v5 02/10] s390: uv: Add dump fields to query
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
References: <20220516090817.1110090-1-frankja@linux.ibm.com>
 <20220516090817.1110090-3-frankja@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220516090817.1110090-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KSnkLxCJDSYRoamqtYKxWE0O4rJ7x8WT
X-Proofpoint-GUID: KSnkLxCJDSYRoamqtYKxWE0O4rJ7x8WT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 impostorscore=0 clxscore=1015 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170087
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/16/22 11:08, Janosch Frank wrote:
> The new dump feature requires us to know how much memory is needed for
> the "dump storage state" and "dump finalize" ultravisor call. These
> values are reported via the UV query call.
> 
> Signed-off-by: Janosch Frank<frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda<imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
