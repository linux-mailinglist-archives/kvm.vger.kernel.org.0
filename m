Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0CF3522EE0
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 11:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239576AbiEKI76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 04:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235806AbiEKI7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 04:59:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9A712FC2D;
        Wed, 11 May 2022 01:59:54 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24B8FBYh032013;
        Wed, 11 May 2022 08:59:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=FboDNicWqvp09ib4HNyfSfVjC4/hJ/gxLv7VkT4/4/o=;
 b=DyjeNwa988nm8MxYQW3hsPrM8fmos/MaYduT9Ma1sDIhpNDnk4s88GxkaQiZHK4iHRyQ
 3JDQntgqNjKk9Mee5gIZJIjqlrdJYvPZ5en1SoI/tKbErDiF1BOZOmnlbnKrSad8Z3kA
 zkM5WfZTr/rvqGFGoVoIt3lHkEJCCj7AB4R9gv+UqG7aMyWKjuWVNtF71rwqWMP3gaky
 AGL0URP3aSHPobE+aT7lg9FgIGva5LxhEoFfZwJBDUt0st9KFsNCMkbHGwzTw+GS+SQ4
 r3XnzRzkdmuQ5liIUjqjjtrfKhMUP74Y+S45tONkJhLyegUpj2WoZanJCL6v5vb9VWC8 Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g09fk8prr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 08:59:53 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24B8lA9w026697;
        Wed, 11 May 2022 08:59:52 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g09fk8pr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 08:59:52 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24B8qVD8021020;
        Wed, 11 May 2022 08:59:50 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3fwgd8w6wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 08:59:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24B8xlq042860984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 08:59:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 332B142047;
        Wed, 11 May 2022 08:59:47 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA13D4203F;
        Wed, 11 May 2022 08:59:46 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.152.224.44])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 11 May 2022 08:59:46 +0000 (GMT)
Message-ID: <1feb731f4c9c3429ab672ae2abe8a763ff8cc3cf.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 0/2] s390x: add migration test for CMM
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com
Date:   Wed, 11 May 2022 10:59:46 +0200
In-Reply-To: <9ab646da-c104-b7a1-70f8-fbd8a6e74150@linux.ibm.com>
References: <20220509120805.437660-1-nrb@linux.ibm.com>
         <20220509160009.3d90cbe4@p-imbrenda>
         <aaf93deff51ccac5d17d8a6d38c399745ecf30c1.camel@linux.ibm.com>
         <9ab646da-c104-b7a1-70f8-fbd8a6e74150@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: l9NMbVQcVmNYuX0zQjYeYjnDt8QP37jA
X-Proofpoint-ORIG-GUID: 8nc9S254fKwaihYk-RI-fHR55y_j1XNX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_02,2022-05-10_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=986 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0
 spamscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205110037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-05-10 at 14:47 +0200, Janosch Frank wrote:
> Having them separate is fine. I'd change the file name to 
> migration-cmm.elf though. We might also want to change the name of
> the 
> first migration test in the future to make the name more specific.

Yes, good thought. I have it on my TODO.
