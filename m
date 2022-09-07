Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEC25AFC4D
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 08:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiIGGYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 02:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiIGGYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 02:24:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D641F2F6
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 23:24:41 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2875k4Kx019568
        for <kvm@vger.kernel.org>; Wed, 7 Sep 2022 06:24:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/d5LBd3L0/tuuXV9BUf/X53O756LdgsPuSfLKyN4qNg=;
 b=PcidvcuXYctTcFSoa55q7gmFGUYFcNPOtnGQEzB1OyaFit+oNPKnPEo7g7yueXophT/C
 udxKNE6gJ00fwpa3FkA11DoHDuWs1noZ2DSL5MlIcXyJlMph8fHlt7syvJ2L9iTjTvEe
 kdPkeINuCLTXebV3AXokGa23o2KF3lgMBXOc22ztJgcQ1jGbnlgkphK9KbjBkza1haXT
 zyfOd49czVJu89cK3oMb9kNBUj328dNGgO1JArBXYzrqqqo55JkeGcktAPxEW6p/Gvp4
 Dhqzm9lNe8qYCyA88IWF8EfYXYmlW5J5VojJpU9pbH/w3QAoKbPhN1vqL6VJwgLqJVlF qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jenej0xby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 06:24:40 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2875maJ2029117
        for <kvm@vger.kernel.org>; Wed, 7 Sep 2022 06:24:40 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jenej0xbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 06:24:40 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2876K7EF001998;
        Wed, 7 Sep 2022 06:24:38 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3jbxj8vput-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 06:24:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2876L5dP41419106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Sep 2022 06:21:05 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A90305204F;
        Wed,  7 Sep 2022 06:24:35 +0000 (GMT)
Received: from [9.145.149.189] (unknown [9.145.149.189])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6A3595204E;
        Wed,  7 Sep 2022 06:24:35 +0000 (GMT)
Message-ID: <ba67f05e-647c-1333-85f5-b05ee44cba74@linux.ibm.com>
Date:   Wed, 7 Sep 2022 08:24:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: create persistent comm-key
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220825131600.115920-1-nrb@linux.ibm.com>
 <20220825131600.115920-3-nrb@linux.ibm.com>
 <d12c0927-fa06-4f27-606e-25971d11e2aa@linux.ibm.com>
 <166247828688.90129.7620152734606584325@t14-nrb>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <166247828688.90129.7620152734606584325@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: W7NmitlphvLGzokQDVZz7pkBpFlsTDh4
X-Proofpoint-ORIG-GUID: a9X_BdKLDFdY5s0d12DRbFCt6p3N6uni
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_03,2022-09-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209070023
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/6/22 17:31, Nico Boehr wrote:
> Quoting Janosch Frank (2022-09-06 11:50:46)
>> Hmmmmmmm(TM)
>>
>> My first thought was that I'd be pretty angry if the CCK changes on a
>> distclean. But the only scenario where this would matter is when the
>> tests are provided to another system.
>>
>> I'm still a bit torn about deleting the CCK especially as there will
>> always be a CCK in the SE header no matter if we specify one or not.
> 
> I really don't have a strong opinion about this. I think it makes sense to clean
> up stuff a Makefile has left behind. But I am honestly just as fine with
> removing this.

Keep it as is, we can still change it when we get complaints. :)
