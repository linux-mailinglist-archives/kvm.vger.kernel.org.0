Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70D752A470
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 16:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348575AbiEQOMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 10:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348704AbiEQOLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 10:11:48 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC1C13CDB;
        Tue, 17 May 2022 07:11:46 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HDv0Ga031209;
        Tue, 17 May 2022 14:11:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mSMaItxt4T8oUen/Link/kOMLjtnx/M7fozhpjYTJwc=;
 b=MY7wkSuVh5x2Mnbo2EdV7KTgZdXgvpZlW4HaJGFN/Bv2V/7v2lhNHd0xYDwZDIa8mouw
 GqnlZyRxy9aCNQb6+1Aev7hk3Ahd+rbXwEh7SEKrlTfywcKmIJzdUvX5KTcpHvSS79K3
 FKnvNwU4F939EKetdu/9EaAB9GjLp+F1jnGyXcyxJjfxIzlkkvhWPNMHZQWsd4MavPrW
 nXnAIdFT2Jqnzi+n0IKp9WV48jXse9I97gzDzFt6UHnPZOO4/4LJgyuDQz2X+SpxdHXu
 3g5xYZJtLPIvAsPp1qcydHLze5qaVphXYlFDqnPBfIpkxB7Bnps4Cw+b/+jN+7/3mqP0 wA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4d1t0ctm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 14:11:45 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HE8P4g016736;
        Tue, 17 May 2022 14:11:44 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3g2428ufaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 14:11:43 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HDvoLR55837118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 13:57:50 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A28C4A4051;
        Tue, 17 May 2022 14:11:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 654BEA4040;
        Tue, 17 May 2022 14:11:40 +0000 (GMT)
Received: from [9.152.224.153] (unknown [9.152.224.153])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 14:11:40 +0000 (GMT)
Message-ID: <31f7a256-818d-d61a-481b-a99fe300eb0d@linux.ibm.com>
Date:   Tue, 17 May 2022 16:11:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v5 01/10] s390x: Add SE hdr query information
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
References: <20220516090817.1110090-1-frankja@linux.ibm.com>
 <20220516090817.1110090-2-frankja@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220516090817.1110090-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: u1_OJj64Ai8dOCJUABqRuQLbOr4-2nnv
X-Proofpoint-GUID: u1_OJj64Ai8dOCJUABqRuQLbOr4-2nnv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 mlxscore=0 mlxlogscore=961 suspectscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
> We have information about the supported se header version and pcf bits
> so let's expose it via the sysfs files.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
