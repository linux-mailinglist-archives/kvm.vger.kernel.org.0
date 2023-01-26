Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816EB67CD0B
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 14:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbjAZN7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 08:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjAZN7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 08:59:03 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088564C0EC
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 05:58:57 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30QDQ5mQ023360;
        Thu, 26 Jan 2023 13:29:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=O+6XlrNNAlnt/xtrZJsAfNuxhU0XmwMNoEHmLMBYDYo=;
 b=KLCn9jPlopX/1zQn6Wg8wAdSEaEjNyQgruqmYthq/or2jvtfb64yOriovQaCUVcnXA7G
 ap0svEJbLF8ddW1/a1Zvc+/mueOmBBUysmBAoC+3oyspSx6gVWo1EfxgPQuMvCqVzXZU
 tvOPStD7BjXGVFo7815uyTVJgscggD86XYHHditV9l1VqDVzC0z9APLpJihnoJ0H2wC4
 Chl5PjCSiEQShghYNhtAlILDALe9LvQosKRzR2Pbuq5u27bHaBhR3Xk4XZPMdug4AzK8
 c0+Vv1MKdOIlACBta8sw0HeoyxRD8KurYTEGx0m3sJ2YHxqpK59qH1x/S7UX1/LMjD4i Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nbtdar2b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 13:29:07 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30QDSPvI032407;
        Thu, 26 Jan 2023 13:29:07 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nbtdar2am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 13:29:07 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30QCgdaj012705;
        Thu, 26 Jan 2023 13:29:06 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3n87p7wjdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 13:29:06 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30QDT4xq43778324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Jan 2023 13:29:05 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6A575805E;
        Thu, 26 Jan 2023 13:29:04 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73B3D5805A;
        Thu, 26 Jan 2023 13:29:03 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 26 Jan 2023 13:29:03 +0000 (GMT)
Message-ID: <dbed0c37-167d-3110-c89a-7a5660825b2e@linux.ibm.com>
Date:   Thu, 26 Jan 2023 08:29:02 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 12/32] block: Factor out hmp_change_medium(), and move to
 block/monitor/
Content-Language: en-US
To:     Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, kraxel@redhat.com, kwolf@redhat.com,
        hreitz@redhat.com, marcandre.lureau@redhat.com,
        dgilbert@redhat.com, mst@redhat.com, imammedo@redhat.com,
        ani@anisinha.ca, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        philmd@linaro.org, wangyanan55@huawei.com, jasowang@redhat.com,
        jiri@resnulli.us, berrange@redhat.com, thuth@redhat.com,
        quintela@redhat.com, stefanb@linux.vnet.ibm.com,
        stefanha@redhat.com, kvm@vger.kernel.org, qemu-block@nongnu.org
References: <20230124121946.1139465-1-armbru@redhat.com>
 <20230124121946.1139465-13-armbru@redhat.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20230124121946.1139465-13-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EeAabsuDQMdsyQwaZVfFO1g5yNqWGSOt
X-Proofpoint-GUID: TIpm8TERSdPKjuGDZ4GZl58-3Rj13dBb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-26_05,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxlogscore=988 mlxscore=0 impostorscore=0 clxscore=1015 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301260126
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/24/23 07:19, Markus Armbruster wrote:
> Signed-off-by: Markus Armbruster <armbru@redhat.com>

Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
