Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBF95BA755
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 09:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiIPHSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 03:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiIPHSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 03:18:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3973B98586;
        Fri, 16 Sep 2022 00:18:14 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28G6XKn6025906;
        Fri, 16 Sep 2022 07:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SHBUOa70oMvvGpW1BYealjIEIY2eeRNxpO4BE1zm22M=;
 b=fmPnqqdtIIE1Di6/WUpix4JWgx5700Sa3PQ47McYDPAN2QDyBCIhHWOKYkYzGaUyymDg
 Pb4zpcei6uyXw+p7i9owxOnOhHGMFhcYPhdk7qczXUYP1q0sWSGkRl2vg7aWkJsXvhGl
 1TapRLmiMLwjw/B2tAMsbh2H0avTvmZIT7ZxQD8zrq5+SEu9eSQN/Uq+gC+yp8kGFDSo
 wOvBO/rMqmMIj/wHFMC0xD65SV39x7viTlLjSCU6PtA0iJ9x8yHu9bsjW3nD4pYtFEWw
 o8Fc+MkJEyNe6LwwUk4AGPdjcrRdaqZ4ST+S2VaAH1IuPDfVxKm2stakvfEoTbNs/5+9 wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jmkyu18d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Sep 2022 07:18:07 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28G6Z4dQ001373;
        Fri, 16 Sep 2022 07:18:07 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jmkyu18cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Sep 2022 07:18:07 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28G76g9P007429;
        Fri, 16 Sep 2022 07:18:05 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3jm9218mf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Sep 2022 07:18:05 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28G7I2rs36569500
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 07:18:02 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38C1C5204E;
        Fri, 16 Sep 2022 07:18:02 +0000 (GMT)
Received: from [9.171.38.23] (unknown [9.171.38.23])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9509F52050;
        Fri, 16 Sep 2022 07:18:01 +0000 (GMT)
Message-ID: <7a469c6e-2a90-e351-702d-b7c9552de515@linux.ibm.com>
Date:   Fri, 16 Sep 2022 09:18:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2] KVM: s390: pci: fix plain integer as NULL pointer
 warnings
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     farman@linux.ibm.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com
References: <20220915175514.167899-1-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220915175514.167899-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m9MOq3LipSH_Jup1wO2LN06WY92VK7Nk
X-Proofpoint-ORIG-GUID: iS7dka_7-D_-Jc-uge95jmFx6LZBbX02
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-16_02,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0 phishscore=0
 mlxscore=0 mlxlogscore=975 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209160051
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 15.09.22 um 19:55 schrieb Matthew Rosato:
> Fix some sparse warnings that a plain integer 0 is being used instead of
> NULL.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Thanks  applied and queued.
