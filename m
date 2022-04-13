Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBE94FF8FB
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 16:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbiDMOej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 10:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233994AbiDMOeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 10:34:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDA856C00;
        Wed, 13 Apr 2022 07:32:14 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DECM4Y009966;
        Wed, 13 Apr 2022 14:32:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=d+iVlETp4AQGSidFyjnohQGsJiiP3ZDa7hjqh3nsejA=;
 b=EH1vDsU83C3PFrUsN6kuJY3Ot7fQ83cA281j43e3ZCRQ5+saV9/nfxge8DgNUMVBwOAR
 CZPMVc5irJGofAeP5x956oPuk7aBQPx1AdJOUknzDgEEz5TFin8qZmbmKiVVNediRS5n
 Rn5SswyLf6LuI7eV4akiMrDrjzIlrvXLeiqgqWFQO/OpiSfKttflLoz4lVe0obAGSdzY
 oGQ1xkhtjPGiKb7y7V7TFtON0zpO6XDchbLqPkTjVvzJ2j9RSgzuusihe+7+SlOvkv/P
 hrG4EoovuY361ohUz58vgdE/Q6fmLYDzBrxq8WYMpRvHbE3Ck+9p3cwBi8R2qg4k4t+D aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fe02t0ep4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 14:32:13 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23DENa6N023584;
        Wed, 13 Apr 2022 14:32:13 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fe02t0enb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 14:32:13 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23DEEAHZ013335;
        Wed, 13 Apr 2022 14:32:11 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3fb1s8nmcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 14:32:10 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23DEW7K229163962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Apr 2022 14:32:07 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB25BAE045;
        Wed, 13 Apr 2022 14:32:07 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85220AE04D;
        Wed, 13 Apr 2022 14:32:07 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.44.32])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Apr 2022 14:32:07 +0000 (GMT)
Message-ID: <dd6fc8061a0c0740e4d9160575e4c3a934df474c.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 4/4] s390x: add selftest for migration
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
Date:   Wed, 13 Apr 2022 16:32:07 +0200
In-Reply-To: <9e87f40c-3270-ebc3-7afe-13a3489940d1@redhat.com>
References: <20220411100750.2868587-1-nrb@linux.ibm.com>
         <20220411100750.2868587-5-nrb@linux.ibm.com>
         <5073d0fc-1017-5be6-2ec5-2709be14c93c@redhat.com>
         <4b7a793f9ab64eb6c5375a12844006bc86c0c752.camel@linux.ibm.com>
         <9e87f40c-3270-ebc3-7afe-13a3489940d1@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fJn5ko0W2hQpEpnLy9bb6A7mVUOE8tBj
X-Proofpoint-GUID: 2Ykopwz27TJVGzCwCTep3bZIq-gZ1zhR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-13_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=980 phishscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-12 at 09:49 +0200, Thomas Huth wrote:
> I think a simple test that checks some register values should not be
> too 
> hard to implement, so I'd prefer that instead of this simple selftest
> ... 
> but if you're too short in time right now, I also won't insist.

It makes sense. I will add it.
